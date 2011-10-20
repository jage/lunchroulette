# -*- encoding : utf-8 -*-
require 'open-uri'
require 'json/pure'
require 'date'

list = JSON.parse(open('http://lunch.serp.se/menu0001.txt').read)

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

File.open('food.db', 'w') do |f|
  Marshal.dump(food_list, f)
end