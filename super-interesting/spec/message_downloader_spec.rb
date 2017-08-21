require_relative "spec_helper"
require_relative "../lib/super-interesting/message_downloader"

describe 'MessageDownloader' do

  subject { MessageDownloader.new }

  it "should fetch standup messages within the specified date range" do
    messages = subject.get_standup_messages(before: '2017/08/19', after: '2017/08/18')

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).not_to be_empty
    expect(messages[0]['location']).to eq('Beaverton')
    expect(messages[1]['body']).not_to be_empty
    expect(messages[1]['location']).to eq('Seattle')
    expect(messages[2]['body']).not_to be_empty
    expect(messages[2]['location']).to eq('SF')
  end

end
