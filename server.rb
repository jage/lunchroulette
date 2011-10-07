# -*- encoding : utf-8 -*-
require 'sinatra/base'

class LiuLunch < Sinatra::Base
  post '/receive' do
    if File.exists?('food.db')
      food_list = File.open('food.db', 'r') do |f|
        Marshal.load(f)
      end
    else
      response = "Ät matlåda."
    end

    puts request.params
    commands = request.params['message'].strip.downcase.split(/\s+/)

    response = case commands.first
    # Match on different spellings
    when /ro{0,1}u{0,1}l{1,2}et{1,2}e/
      if commands[1]
        food_list = food_list.select {|d| d[1].downcase.strip == commands[1] }
      end
      rnd = Random.new.rand(0..(food_list.size - 1))
      choice = food_list[rnd]
      "Du ska äta \"#{choice[0]}\" på #{choice[1]}"
    else
      menu = food_list.select {|d| d[1].downcase.strip == commands.join }.collect {|d| "* #{d[0]}" }.join("\n")
      unless menu.empty?
        menu
      else
        "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
      end
    end
    puts response
    response
  end
end

if __FILE__ == $0
  LiuLunch.run! :host => '0.0.0.0', :port => 8293
end
