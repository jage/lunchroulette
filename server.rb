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
    command = request.params['message'].strip.downcase

    response = case command
    # Match on different spellings
    when /ro{0,1}u{0,1}l{1,2}et{1,2}e/
      rnd = Random.new.rand(0..(food_list.size - 1))
      choice = food_list[rnd]
      "Du ska äta \"#{choice[0]}\" på #{choice[1]}"
    else
      menu = food_list.select {|d| d[1].downcase.strip == command }.collect {|d| "* #{d[0]}" }.join("\n")
      unless menu.empty?
        menu
      else
        "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny."
      end
    end
    puts response
    response
  end
end

if __FILE__ == $0
  LiuLunch.run! :host => '0.0.0.0', :port => 8293
end
