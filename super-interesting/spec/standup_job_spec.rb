require "ostruct"
require "json"

require_relative "spec_helper"
require_relative "../lib/super-interesting/standup_job"

describe 'StandupJob' do

  let(:mock_message_downloader) { double('MessageDownloader') }

  subject { StandupJob.new(message_downloader: mock_message_downloader) }

  it "'Interestings' from standup messages" do
    expect(mock_message_downloader)
      .to receive(:get_standup_messages)
      .once.and_return(JSON.parse(File.read(fixture_path('standup_job/get_todays_standup_messages.json')))['messages'])

    messages = subject.run(before: '2017/08/19', after: '2017/08/18')

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).to eq('yolo')
    expect(messages[1]['body']).to eq('lol')
    expect(messages[2]['body']).to eq('Just some interesting stuff')
  end

end
