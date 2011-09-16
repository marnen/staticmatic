require 'rubygems'
require 'compass'
require 'haml'
require 'sass'
require 'sass/plugin'
require 'tilt'
require 'rack'
require 'rack/handler/webrick'
require 'cgi'
require 'fileutils'


module StaticMatic
end

["render", "build", "setup", "server", "helpers", "rescue"].each do |mixin|
  require File.join(File.dirname(__FILE__), "staticmatic", "mixins", mixin)
end

["base", "configuration", "error", "server", "helpers", "template_error", "ambiguous_template_error", "compass"].each do |lib|
  require File.join(File.dirname(__FILE__), "staticmatic", lib)
end
