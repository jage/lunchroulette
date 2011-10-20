# -*- encoding : utf-8 -*-
require 'sinatra/base'
require "sinatra/reloader" # TODO: Only in development

DATABASE = 'food.db'

class DatabaseError < RuntimeError; end

raise(DatabaseError, "Could not find #{DATABASE}") unless File.exists?(DATABASE)

class LiuLunch < Sinatra::Base
  post '/receive' do
    if File.exists?(DATABASE)
      @food_list = File.open(DATABASE, 'r') do |f|
        Marshal.load(f)
      end
    else
      response = "Ät matlåda."
    end

    puts request.params

    commands = request.params['message'].strip.downcase.split(/\s+/)
    response = match_commands(commands)

    puts response
    response
  end

private

  def match_commands(commands)
    case commands.first
    when /ro{0,1}u{0,1}l{1,2}et{1,2}e/
      roulette(commands)
    else
      menu = @food_list.select {|d| d[:restaurant].downcase.strip == commands.join }
      unless menu.empty?
        menu.collect {|row| "* #{row[:food]}" }.join("\n")
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
    rnd = Random.new.rand(0..(@food_list.size - 1))
    choice = @food_list[rnd]
    "Du ska äta \"#{choice[:food]}\" på #{choice[:restaurant]}"
  end

  def help
    "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
  end
end

if __FILE__ == $0
  LiuLunch.run! :host => '0.0.0.0', :port => 8293
end
