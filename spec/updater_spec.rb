# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'
require 'shamrock'

def database
  File.join(File.dirname(__FILE__), 'tmp', 'food.db')
end

# FIXME Shamrock block Service { Updater ...}

describe "updater" do
  it 'should create food.db' do
    response = fixture('menu0001.txt').read
    rack = proc {|env| [200, {"Content-Type" => "text/html"}, [response]]}
    @lunch_service = Shamrock::Service.new(rack)
    @lunch_service.start

    # Time machine
    Timecop.freeze(Time.utc(2011,10, 17, 9, 0)) do
      Updater.run(@lunch_service.url)
    end

    @lunch_service.stop

    File.exist?(database).should == true

    food_list = File.open(database, 'r') do |f|
      Marshal.load(f)
    end

    food_list.size.should == 18

    # Cleanup
    #FileUtils.rm(database)
  end
end
