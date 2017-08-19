require "super-interesting"
require "ostruct"
require "base64"

require_relative "spec_helper"

describe 'StandupJob' do
  let(:get_standup_messages_response) { 
    OpenStruct.new(body: File.read(fixture_path('http/get_messages_response.json'))) 
  }
  let(:standup_message_1_response) {
    OpenStruct.new(body: File.read(fixture_path('http/15df90e02e17733a.json')))  
  }
  let(:standup_message_2_response) {
    OpenStruct.new(body: File.read(fixture_path('http/15df90e3e21d178c.json')))  
  }
  let(:standup_message_3_response) {
    OpenStruct.new(body: File.read(fixture_path('http/15df90e6e6450867.json')))  
  }

  subject { StandupJob.new }

  it "should get today's standup messages" do
    expect_any_instance_of(Net::HTTP)
      .to receive(:request)
      .and_return(
        get_standup_messages_response,
        standup_message_1_response,
        standup_message_2_response,
        standup_message_3_response
      )

    messages = subject.get_todays_standup_messages

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).not_to be_empty
    expect(messages[1]['body']).not_to be_empty
    expect(messages[2]['body']).not_to be_empty
  end

  it "should decode the message body of each email" do
    messages = JSON.parse(File.read(fixture_path('standup_job/get_todays_standup_messages.json')))['messages']
    expected_decoded_first_message = Base64.urlsafe_decode64(messages[0]['body'])
    expected_decoded_second_message = Base64.urlsafe_decode64(messages[1]['body'])
    expected_decoded_third_message = Base64.urlsafe_decode64(messages[2]['body'])

    subject.decode(messages)
    
    expect(messages[0]['body']).to eq(expected_decoded_first_message)
    expect(messages[1]['body']).to eq(expected_decoded_second_message)
    expect(messages[2]['body']).to eq(expected_decoded_third_message)
  end
  
  it "return an aggregate of the 'Interestings' section across all the messages"

end
