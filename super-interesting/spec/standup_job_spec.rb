require "super-interesting"
require "ostruct"
require "base64"

require_relative "spec_helper"

describe 'StandupJob' do
  let(:get_standup_messages_response) { OpenStruct.new(body: File.read(fixture_path('http/get_messages_response.json'))) }
  let(:standup_message_1_response) { OpenStruct.new(body: File.read(fixture_path('http/15df90e02e17733a.json'))) }
  let(:standup_message_2_response) { OpenStruct.new(body: File.read(fixture_path('http/15df90e3e21d178c.json'))) }
  let(:standup_message_3_response) { OpenStruct.new(body: File.read(fixture_path('http/15df90e6e6450867.json'))) }

  subject { StandupJob.new }

  before do
    expect_any_instance_of(Net::HTTP)
      .to receive(:request)
      .and_return(
        get_standup_messages_response,
        standup_message_1_response,
        standup_message_2_response,
        standup_message_3_response
      )
  end

  it "should fetch today's standup messages" do
    messages = subject.get_todays_standup_messages

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).not_to be_empty
    expect(messages[1]['body']).not_to be_empty
    expect(messages[2]['body']).not_to be_empty
  end

  it "returns an aggregate of the 'Interestings' section across all the messages" do
    messages = subject.run
    
    expect(messages.length).to eq(3)
    expect(messages[0]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[0]['body']).to end_with('It&#39;ll grow increasingly useful and relevant in the future!</p>')
    expect(messages[1]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[1]['body']).to end_with('it is something you would be interested in.</h1>')
    expect(messages[2]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[2]['body']).to end_with('<h3>David is leaving us....</h3>')
  end

end
