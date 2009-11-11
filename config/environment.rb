require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
vendored_rgtk = File.join(File.dirname(__FILE__), '..', 'vendor', 'rgtk', 'lib')
$LOAD_PATH.unshift(vendored_rgtk) if File.exists?(vendored_rgtk)

require 'rgtk'
require 'webkit'
require 'vte'

Rgtk.root = File.expand_path("#{File.dirname(__FILE__)}/..") unless defined?(RGTK_ROOT)

class SozdatApp < Rgtk::App
end

App = SozdatApp.instance
