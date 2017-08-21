require "json"

require_relative "spec_helper"
require_relative "../lib/super-interesting/standup_job"

describe 'StandupJob' do

  let(:mock_message_downloader) { double('MessageDownloader') }
  let(:mock_message_decoder) { double('MessageDecoder') }
  let(:mock_category_parser) { double('CategoryParser') }

  subject { StandupJob.new(
    message_downloader: mock_message_downloader,
    message_decoder: mock_message_decoder,
    category_parser: mock_category_parser
    )
  }

  before do
    expect(mock_message_downloader)
      .to receive(:get_standup_messages)
      .once.and_return(JSON.parse(File.read(fixture_path('standup_messages.json'))))
    
    expect(mock_message_decoder)
      .to receive(:decode)
      .once.and_return(JSON.parse(File.read(fixture_path('decoded_standup_messages.json'))))

    expect(mock_category_parser)
      .to receive(:parse_out_category)
      .once.and_return(JSON.parse(File.read(fixture_path('standup_messages_with_only_interestings.json'))))
  end

  it "should return the 'Interestings' from each standup message" do
    messages = subject.run(before: '2017/08/19', after: '2017/08/18')

    expect(messages.length).to eq(3)
    expect(messages[0]['body']).to eq('yolo')
    expect(messages[1]['body']).to eq('lol')
    expect(messages[2]['body']).to eq('Just some interesting stuff')
  end

end
