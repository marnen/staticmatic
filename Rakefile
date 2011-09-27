require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# require 'rake'
require 'jeweler'
require 'spec/rake/spectask'
require File.expand_path("../lib/staticmatic", __FILE__)

Jeweler::Tasks.new do |gem|
  gem.name        = "staticmatic2"
  gem.email       = "gilbertbgarza@gmail.com"
  gem.license     = "MIT"
  gem.summary     = "Build Amazon S3 static websites using modern dynamic tools"
  gem.homepage    = "http://github.com/mindeavor/staticmatic2"
  gem.executables = "staticmatic"
  gem.authors     = ["Stephen Bartholomew", "Gilbert B Garza"]

  gem.description = <<-EOF
    StaticMatic helps you quickly create maintainable Amazon S3 static websites using
    tools such as Haml and Sass.
    
    Quickly deploy to services such as Amazon S3 in a single command.
  EOF
  
  gem.rubyforge_project = "staticmatic2"
  
  gem.files.include "[A-Z]*", "{bin,lib,spec}/**/*"
  gem.files.exclude "spec/sandbox/tmp", "spec/sandbox/test_site/site/*"
end

Jeweler::RubygemsDotOrgTasks.new

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  # spec.spec_opts = ['--options', 'spec/spec.opts']
end
