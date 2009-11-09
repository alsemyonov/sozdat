$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "#{File.dirname(__FILE__)}/../vendor/gems/environment.rb"
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'vendor', 'rgtk', 'lib')
require 'rgtk'

Rgtk.root = File.expand_path("#{File.dirname(__FILE__)}/..") unless defined?(RGTK_ROOT)

class SozdatApp < Rgtk::App
end

App = SozdatApp.instance
