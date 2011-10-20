# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

def database
  File.join(File.dirname(__FILE__), 'tmp', 'food.db')
end

describe "updater" do
  it 'should create food.db' do
    stub_request(:get, "http://lunch.serp.se/menu0001.txt").
      to_return(fixture('menu0001.txt'))

    Updater.run

    File.exist?(database).should == true

    food_list = File.open(database, 'r') do |f|
      Marshal.load(f)
    end

    food_list.size.should == 18

    # Cleanup
    FileUtils.rm(database)
  end
end