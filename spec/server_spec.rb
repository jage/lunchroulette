# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

# Use fixture food.db
def database
  fixture('food.db')
end

describe "LiULunch" do
  include Rack::Test::Methods

  # App to be used
  def app
    @app ||= LiuLunch
  end

  it "should respond to /receive" do
    post '/receive', {:message => 'Roulette'}
    last_response.should be_ok
  end

  it "should offer help for random command" do
    post '/receive', {:message => 'blablablabla'}
    last_response.body.should == "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
  end

  it "should offer todays Kårallen meny" do
    Timecop.freeze(Time.utc(2011,10, 3, 9, 0)) do
      post '/receive', {:message => 'Kårallen'}
    end

    last_response.body.should == "* Mexikansk kyckling med ris
* Cajunköttgryta med chorizo serveras med kokt potatis
* Nudelwok med strimlat fläskkött , bambuskott &  vattenkastanjer
* Mexikansk quornfilé med ris
* Hemlagad ärtsoppa med fläsk (Köp till nystekta pannkakor med sylt & grädde för 15:-)"
  end

  it "should offer todays Blåmesen meny" do
    Timecop.freeze(Time.utc(2011,10, 3, 9, 0)) do
      post '/receive', {:message => 'Blåmesen'}
    end

    last_response.body.should == "* Ärtsoppa & pannkakor m. sylt & grädde
* Gratinerad häxkittel
* Broccoligratäng
* Fetaostfylld lövbiff med tzatziki
* Räksoppa"
  end

  it "should offer todays Zenit meny" do
    Timecop.freeze(Time.utc(2011,10, 3, 9, 0)) do
      post '/receive', {:message => 'Zenit'}
    end

    last_response.body.should == "* Färskosttoppad FÄRSBIFF serveras med salviasås och Lasses hemlagade potatismos
* Ugnsstek TORSKRYGG med smörbrynta champinjoner och räkor serveras med hemlagat potatismos
* Veg Ädelostbakad rotfruktslåda med grädde och örter serveras med hemlagat potatismos"
  end
end
