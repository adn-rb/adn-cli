# encoding: UTF-8

require 'minitest/spec'
require 'minitest/autorun'

begin
  require 'minitest/pride'
rescue LoadError
  puts "Install the minitest gem if you want colored output"
end

require "find"

%w{./lib}.each do |load_path|
  Find.find(load_path) { |f| require f if f.match(/\.rb$/) }
end
