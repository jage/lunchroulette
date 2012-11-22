# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'
require 'shamrock'

def with_server(rack, &block)
  service = Shamrock::Service.new(rack, :AccessLog => [], :Logger => WEBrick::Log::new("/dev/null", 7))
  service.start
  block.call(service.url)
  service.stop
end

describe "updater" do
  it 'should save food list' do
    response = fixture('menu0001.txt').read
    rack = proc { |env| [200, {}, [response]]}

    Updater.should_receive(:save) do |food_list|
      food_list.size.should eq(18)
    end

    with_server(rack) do |url|
      Timecop.freeze(Time.utc(2011,10, 17, 9, 0)) do
        Updater.run(url)
      end
    end
  end
end
