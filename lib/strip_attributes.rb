require 'active_support'
require 'active_support/core_ext/array/wrap'
require 'active_model'

module ActiveModel::Validations::HelperMethods
  # Strips whitespace from model fields and converts blank values to nil.
  def h_attributes!(options = nil)
    StripAttributes.register_callback(self, options) do |value|
      StripAttributes.h(value)
    end
  end

  def escape_javascript!(options = nil)
    StripAttributes.register_callback(self, options) do |value|
      throw :skip if value.blank?
      ActionController::Base.helpers.sanitize(value)
    end
  end

  def strip_tags!(options = nil)
    StripAttributes.register_callback(self, options) do |value|
      throw :skip if value.blank?
      ActionController::Base.helpers.strip_tags(value)
    end
  end

  # For backward compatibility. Should be removed in future.
  def h(*args)
    StripAttributes.h(*args)
  end

  def strip_attributes!(options = nil)
    blank_value = options[:blank_value] if options
    StripAttributes.register_callback(self, options) do |value|
      value.blank? ? blank_value : StripAttributes.strip(value)
    end
  end
end

module StripAttributes
  module_function

  # From https://github.com/rmm5t/strip_attributes/blob/master/lib/strip_attributes.rb
  MULTIBYTE_WHITE = "\u180E\u200B\u200C\u200D\u2060\uFEFF"
  MULTIBYTE_SPACE = /[[:space:]#{MULTIBYTE_WHITE}]/
  MULTIBYTE_SUPPORTED  = "\u0020" == " "

  def strip(value)
    value =
      if MULTIBYTE_SUPPORTED && Encoding.compatible?(value, MULTIBYTE_SPACE)
        value.gsub(/\A#{MULTIBYTE_SPACE}+|#{MULTIBYTE_SPACE}+\z/, "")
      else
        value.strip
      end
    value.gsub(/\u00a0/, ' ')
  end

  def h(value)
    value.to_s.to_valid_utf8.gsub(/</,'&lt;').gsub(/>/,'&gt;').gsub(/\u00a0/, ' ')
  end

  def prepare_options(options)
    options ||= {}
    %i[except only].each { |x| options[x] = Array.wrap(options[x]).map(&:to_s) if options[x] }
    options
  end

  def register_callback(model, options)
    options = prepare_options(options)
    model.before_validation do |record|
      attributes = StripAttributes.fetch_attributes(record, options)
      attributes.each do |attr, value|
        next unless value.respond_to?(:gsub)
        next if record.respond_to?("#{attr}_changed?") && !record.send("#{attr}_changed?")
        catch(:skip) { record.send("#{attr}=", yield(value)) }
      end
    end
  end

  def fetch_attributes(record, options)
    attributes = record.attributes
    # support for Virtus - it has symbolized attrs hash.
    attributes = attributes.stringify_keys if attributes.first.first.is_a?(Symbol)
    if except = options[:except]
      attributes.except(*except)
    elsif only = options[:only]
      Hash[only.map { |i| [i, record.send(i)] }]
    else
      attributes
    end
  end
end
