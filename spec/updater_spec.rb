# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'
require 'shamrock'

def database
  File.join(File.dirname(__FILE__), 'tmp', 'food.db')
end

# FIXME Shamrock block Service { Updater ...}

describe "updater" do
  it 'should save food list' do
    response = fixture('menu0001.txt').read
    rack = proc {|env| [200, {"Content-Type" => "text/html"}, [response]]}
    @lunch_service = Shamrock::Service.new(rack)
    @lunch_service.start

    Updater.should_receive(:save) do |food_list|
      food_list.size.should eq(18)
    end

    # Time machine
    Timecop.freeze(Time.utc(2011,10, 17, 9, 0)) do
      Updater.run(@lunch_service.url)
    end

    @lunch_service.stop
  end
end
