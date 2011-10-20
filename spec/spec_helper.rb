# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), '..', 'updater.rb')
require File.join(File.dirname(__FILE__), '..', 'server.rb')

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'sinatra'
require 'webmock/rspec'
require 'rack/test'
require 'timecop'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def fixture_path
  File.expand_path(File.join('..', 'fixtures'), __FILE__)
end

def fixture(file)
  File.new(File.join(fixture_path, file))
end