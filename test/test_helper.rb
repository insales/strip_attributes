require 'test/unit'
require 'active_model'
require 'virtus'
require 'pry'
require 'rubygems'
require 'strip_attributes'
begin require 'redgreen' if ENV['TM_FILENAME'].nil?; rescue LoadError; end

PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

$LOAD_PATH.unshift "#{PLUGIN_ROOT}/lib"
