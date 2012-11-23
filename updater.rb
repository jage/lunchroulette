# -*- encoding : utf-8 -*-
require 'open-uri'
require 'json/pure'
require 'date'
require 'mongo'

class Updater
  def self.run(url = 'http://lunch.serp.se/menu0001.txt')
    list = JSON.parse(open(url).read)

    # Convert Date
    list.each do |item|
      d = item["date"]
      item["date"] = Time.parse("#{d['year']}-#{d['month']}-#{d['day']}").to_date
    end
    todays_food = list.select {|l| l["date"] == Date.today }.first

    food_list = []

    todays_food["menus"].each do |restaurant|
      food_list += restaurant["dishes"].collect {|d| {:food => d["name"], :restaurant => restaurant["name"]} }
    end

    food_list += ["Big Mac & co", "Chicken Nuggets"].collect {|x| {:food => x, :restaurant => "McDonalds"}}
    food_list += ["Pasta"].collect {|x| {:food => x, :restaurant => "Pastavagnen"}}
    food_list += ["Sallad", "Macka"].collect {|x| {:food => x, :restaurant => "Cesam"}}

    save(food_list)
  end

  def self.save(food_list)
    record = { 'kind' => 'latest', 'dump' => Marshal.dump(food_list) }
    key = {'kind' => 'latest'}
    mongo = Mongo::Connection.new.db
    if mongo['marshal'].find_one(key)
      mongo['marshal'].update(key, record)
    else
      mongo['marshal'].insert(record)
    end
  end
end

if __FILE__ == $0
  Updater.run
end
