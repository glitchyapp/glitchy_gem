$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'bundler/setup'
require 'json'

require 'glitchy_gem'

RSpec.configure do |config|
  # give me something to do!
end
