require File.join(File.dirname(__FILE__), '..', 'updater.rb')

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false