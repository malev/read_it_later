#!/usr/bin/env rake

require 'bundler'
#Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

require 'rdoc/task'
require File.expand_path('../lib/read_it_later/version', __FILE__)
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  #rdoc.title = "linkedin #{ReadItLater::Version::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
