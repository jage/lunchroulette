require File.dirname(__FILE__) + '/spec_helper_sinatra'

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
end
