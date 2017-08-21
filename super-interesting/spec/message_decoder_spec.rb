require "json"

require_relative "spec_helper"
require_relative "../lib/super-interesting/message_decoder"

describe 'MessageDecoder' do

  let(:messages) { JSON.parse(File.read(fixture_path('standup_messages.json'))) }

  subject { MessageDecoder.new }

  it "should decode the body of messages" do
    decoded_messages = subject.decode(messages)

    expect(decoded_messages.length).to eq(3)
    expect(messages[0]['body']).to eq('<h2>Interestings</h2>yolo<h2>Events</h2>')
    expect(messages[1]['body']).to eq('<h2>Interestings</h2>lol-------------')
    expect(messages[2]['body']).to eq('<h1>Some Title</h1><h2>Interestings</h2>Just some interesting stuff<h2>Events</h2>-------------')
  end

end
