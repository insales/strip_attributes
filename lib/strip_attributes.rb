require 'active_support'

module StripAttributes
  # Strips whitespace from model fields and converts blank values to nil.
  def h_attributes!(options = nil)
    before_validation do |record|
      attributes = StripAttributes.narrow(record, options)
      attributes.each do |attr, value|
        if value.respond_to?(:gsub)
          next if record.respond_to?("#{attr}_changed?") and !record.send("#{attr}_changed?")
          record.send( "#{attr}=", self.class.h(value))
        end
      end
    end
  end

  def escape_javascript!(options = nil)
    before_validation do |record|
      attributes = StripAttributes.narrow(record, options)
      attributes.each do |attr, value|
        if value.respond_to?(:gsub)
          next if record.respond_to?("#{attr}_changed?") and !record.send("#{attr}_changed?")
          record.send("#{attr}=", ActionController::Base.helpers.sanitize(value)) if value.present?
        end
      end
    end
  end

  def strip_tags!(options = nil)
    before_validation do |record|
      attributes = StripAttributes.narrow(record, options)
      attributes.each do |attr, value|
        if value.respond_to?(:gsub)
          next if record.respond_to?("#{attr}_changed?") and !record.send("#{attr}_changed?")
          record.send("#{attr}=", ActionController::Base.helpers.strip_tags(value)) if value.present?
        end
      end
    end
  end

  def h(value)
    value.to_s.to_valid_utf8.gsub(/</,'&lt;').gsub(/>/,'&gt;').gsub(/\u00a0/, ' ')
  end

  def strip_attributes!(options = nil)
    blank_value = (options.nil? || !options.has_key?(:blank_value)) ? nil : options[:blank_value]

    before_validation do |record|
      attributes = StripAttributes.narrow(record, options)
      attributes.each do |attr, value|
        if value.respond_to?(:strip)
          next if record.respond_to?("#{attr}_changed?") and !record.send("#{attr}_changed?")
          record.send( "#{attr}=", value.blank? ? blank_value : ActiveSupport::Multibyte::Chars.new(value).strip.to_s.gsub(/\u00a0/, ' '))
        end
      end
    end
  end

  # Necessary because Rails has removed the narrowing of attributes using :only
  # and :except on Base#attributes
  def self.narrow(record, options)
    attributes = record.attributes
    if options.nil?
      attributes
    else
      if except = options[:except]
        except = Array(except).collect { |attribute| attribute.to_s }
        attributes.except(*except)
      elsif only = options[:only]
        only = Array(only).collect { |attribute| attribute.to_s }
        attributes.slice(*only).merge Hash[only.map { |i| [i, record.send(i)]}]
      else
        raise ArgumentError, "Options does not specify :except or :only (#{options.keys.inspect})"
      end
    end
  end
end
