# -*- encoding : utf-8 -*-
require 'sinatra/base'
require 'mongo'

class LiuLunch < Sinatra::Base
  post '/receive' do
    return response = 'Ät matlåda' unless food_list

    commands = request.params['message'].strip.downcase.split(/\s+/)
    match_commands(commands) || help
  end

private

  def food_list
    return @food_list if @food_list
    mongo = Mongo::Connection.new.db
    if marshal = mongo['marshal'].find_one({ 'kind' => 'latest' })
      @food_list = Marshal.load(marshal['dump'])
    end
  end

  def match_commands(commands)
    command = commands.first
    if /ro{0,1}u{0,1}l{1,2}et{1,2}e/.match(command)
      roulette(commands)
    elsif restaurants.include?(command)
      menu_for(command)
    end
  end

  def menu_for(restaurant)
    menu = food_list.select { |f| f[:restaurant].downcase.strip == restaurant }
    menu.map { |r| "* #{r[:food].strip}" }.join("\n")
  end

  def restaurants
    food_list.map { |f| f[:restaurant].downcase.strip }.uniq
  end

  def roulette(commands)
    list = food_list
    if commands[1] && restaurants.include?(commands[1].to_s.downcase.strip)
      list.select! {|d| d[:restaurant].downcase.strip == commands[1] }
    end
    choice = list[rand(list.size)]
    "Du ska äta \"#{choice[:food]}\" på #{choice[:restaurant]}"
  end

  def help
    "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
  end
end