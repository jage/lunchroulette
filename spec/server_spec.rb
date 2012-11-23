# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'


describe "LiULunch" do
  include Rack::Test::Methods

  # App to be used
  def app
    @app ||= LiuLunch
  end

  before do
    LiuLunch.any_instance.stub(:food_list).and_return(food_list)
  end

  it "should respond to /receive" do
    post '/receive', {:message => 'Roulette'}
    last_response.should be_ok
  end

  it "should offer random food to roulette command" do
    post '/receive', {:message => 'Roulette'}
    last_response.body.should match /^Du ska äta "(.*)" på (.*)$/
  end

  it "should offer help for random command" do
    post '/receive', {:message => 'blablablabla'}
    last_response.body.should == "Skicka 'Roulette' om du vill ha matförslag eller 'Kårallen', 'Blåmesen', 'Zenit' för att se meny. Det går även att skicka t.ex 'Roulette Kårallen' för att slumpa i kårallens meny."
  end

  it "should offer todays Kårallen meny" do
    post '/receive', {:message => 'Kårallen'}
    last_response.body.should == "* Mexikansk kyckling med ris
* Cajunköttgryta med chorizo serveras med kokt potatis
* Nudelwok med strimlat fläskkött , bambuskott &  vattenkastanjer
* Mexikansk quornfilé med ris
* Hemlagad ärtsoppa med fläsk (Köp till nystekta pannkakor med sylt & grädde för 15:-)"
  end

  it "should offer todays Blåmesen meny" do
    post '/receive', {:message => 'Blåmesen'}
    last_response.body.should == "* Ärtsoppa & pannkakor m. sylt & grädde
* Gratinerad häxkittel
* Broccoligratäng
* Fetaostfylld lövbiff med tzatziki
* Räksoppa"
  end

  it "should offer todays Zenit meny" do
    post '/receive', {:message => 'Zenit'}
    last_response.body.should == "* Färskosttoppad FÄRSBIFF serveras med salviasås och Lasses hemlagade potatismos
* Ugnsstek TORSKRYGG med smörbrynta champinjoner och räkor serveras med hemlagat potatismos
* Veg Ädelostbakad rotfruktslåda med grädde och örter serveras med hemlagat potatismos"
  end
end

def food_list
  [{:food=>"Ärtsoppa & pannkakor m. sylt & grädde", :restaurant=>"Blåmesen"},
   {:food=>"Gratinerad häxkittel", :restaurant=>"Blåmesen"},
   {:food=>"Broccoligratäng", :restaurant=>"Blåmesen"},
   {:food=>"Fetaostfylld lövbiff med tzatziki", :restaurant=>"Blåmesen"},
   {:food=>"Räksoppa", :restaurant=>"Blåmesen"},
   {:food=>"Mexikansk kyckling med ris ", :restaurant=>"Kårallen"},
   {:food=>"Cajunköttgryta med chorizo serveras med kokt potatis", :restaurant=>"Kårallen"},
   {:food=>"Nudelwok med strimlat fläskkött , bambuskott &  vattenkastanjer", :restaurant=>"Kårallen"},
   {:food=>"Mexikansk quornfilé med ris", :restaurant=>"Kårallen"},
   {:food=>"Hemlagad ärtsoppa med fläsk (Köp till nystekta pannkakor med sylt & grädde för 15:-)", :restaurant=>"Kårallen"},
   {:food=>"Färskosttoppad FÄRSBIFF serveras med salviasås och Lasses hemlagade potatismos", :restaurant=>"Zenit"},
   {:food=>"Ugnsstek TORSKRYGG med smörbrynta champinjoner och räkor serveras med hemlagat potatismos", :restaurant=>"Zenit"},
   {:food=>" Veg Ädelostbakad rotfruktslåda med grädde och örter serveras med hemlagat potatismos", :restaurant=>"Zenit"},
   {:food=>"Big Mac & co", :restaurant=>"McDonalds"},
   {:food=>"Chicken Nuggets", :restaurant=>"McDonalds"},
   {:food=>"Pasta", :restaurant=>"Pastavagnen"},
   {:food=>"Sallad", :restaurant=>"Cesam"},
   {:food=>"Macka", :restaurant=>"Cesam"}]
end
