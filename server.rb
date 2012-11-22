# -*- encoding : utf-8 -*-
require 'sinatra/base'
require "sinatra/reloader" # TODO: Only in development
require 'mongo'

class LiuLunch < Sinatra::Base
  post '/receive' do
    @food_list = food_list

    return response = 'Ät matlåda' unless @food_list

    commands = request.params['message'].strip.downcase.split(/\s+/)
    match_commands(commands)
  end

private

  def food_list
    mongo = Mongo::Connection.new.db
    if marshal = mongo['marshal'].find_one({ 'kind' => 'latest' })
      Marshal.load(marshal['dump'])
    end
  end

  def match_commands(commands)
    case commands.first
    when /ro{0,1}u{0,1}l{1,2}et{1,2}e/
      roulette(commands)
    else
      menu = @food_list.select {|d| d[:restaurant].downcase.strip == commands.join }
      unless menu.empty?
        menu.collect {|row| "* #{row[:food].strip}" }.join("\n")
      else
        help
      end
    end
  end

  def roulette(commands)
    # If roulette <filter>, filter food_list for <filter>
    if commands[1]
      @food_list = @food_list.select {|d| d[:restaurant].downcase.strip == commands[1] }
    end
    choice = @food_list[rand(@food_list.size)]
    "Du ska äta \"#{choice[:food]}\" på #{choice[:restaurant]}"
  end

  def help
    "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
  end
end