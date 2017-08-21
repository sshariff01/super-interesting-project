require "json"

require_relative "spec_helper"
require_relative "../lib/super-interesting/category_parser"

describe 'CategoryParser' do
  let(:messages) { JSON.parse(File.read(fixture_path('decoded_standup_messages.json'))) }

  subject { CategoryParser.new(category: 'Interestings') }

  it "should parse out the specified category from each message" do
    parsed_messages = subject.parse_out_category(messages: messages)

    expect(parsed_messages.length).to eq(3)
    expect(parsed_messages[0]['body']).to eq('yolo')
    expect(parsed_messages[1]['body']).to eq('lol')
    expect(parsed_messages[2]['body']).to eq('Just some interesting stuff')
  end

end
