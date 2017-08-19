require "super-interesting"
require "ostruct"

require_relative "spec_helper"

describe 'GetAllInterestingsUseCase' do
  let (:get_standup_messages_response) { 
    OpenStruct.new(body: File.read(fixture_path('list_today_interestings_response.json'))) 
  }

  subject { GetAllInterestingsUseCase.new }

  it "should get today's standup messages" do
    expect_any_instance_of(Net::HTTP).to receive(:request).and_return(get_standup_messages_response)

    result = subject.get_todays_standup_messages

    expect(result['messages'].length).to eq(3)
  end

  it "should get the contents of each email"

  it "should convert the message body of each email into a human readable format"
  
  it "should filter out everything, except for the Interestings section, out of the message body"

end
