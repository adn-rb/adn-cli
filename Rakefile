#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end
