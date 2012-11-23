# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), '..', 'updater.rb')
require File.join(File.dirname(__FILE__), '..', 'server.rb')

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'sinatra'
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


module CustomMatchers
  class BePartOf
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      @expected.include?(target)
    end

    def failure_message
      "expected #{@target.inspect} to be part of #{@expected}"
    end

    def negative_failure_message
      "expected #{@target.inspect} not to be part of #{@expected}"
    end
  end

  def be_part_of(expected)
    BePartOf.new(expected)
  end
end
