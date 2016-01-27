require 'spec_helper'

def mock_fixture(fixture)
  mock = File.open("spec/fixtures/#{fixture}.html").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelTwitterPhoto, lita_handler: true do
  it 'puts the twitter photo on the response' do
    mock_fixture('sample')
    send_message ('https://twitter.com/th3fallen/status/689501399084855297')
    expect(replies.last).to eq('https://pbs.twimg.com/media/CZmsv0SWYAAaO1N.png')
  end
end
