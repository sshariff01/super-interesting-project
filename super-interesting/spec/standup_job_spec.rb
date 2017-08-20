require "super-interesting"
require "ostruct"
require "base64"

require_relative "spec_helper"

describe 'StandupJob' do

  subject { StandupJob.new }

  it "should fetch standup messages within the specified date range" do
    messages = subject.get_standup_messages(before: '2017/08/19', after: '2017/08/18')

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).not_to be_empty
    expect(messages[1]['body']).not_to be_empty
    expect(messages[2]['body']).not_to be_empty
  end

  it "should parse out the 'Interestings' section for each messages" do
    messages = subject.run(before: '2017/08/19', after: '2017/08/18')

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[0]['body']).to end_with('<h3>David is leaving us....</h3>')
    expect(messages[1]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[1]['body']).to end_with('it is something you would be interested in.</h1>')
    expect(messages[2]['body']).to start_with('<h2>Interestings</h2>')
    expect(messages[2]['body']).to end_with('It&#39;ll grow increasingly useful and relevant in the future!</p>')
  end

end
