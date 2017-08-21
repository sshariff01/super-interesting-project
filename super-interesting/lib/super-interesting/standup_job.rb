class StandupJob
  attr_reader :message_downloader, :message_decoder
  
  def initialize(message_downloader:, message_decoder:)
    @message_downloader = message_downloader
    @message_decoder = message_decoder
  end
  
  def run(before:, after:)
    messages = message_downloader.get_standup_messages(before: before, after: after)
    decoded_messages = message_decoder.decode(messages)
    parse_interestings_from(decoded_messages)
    decoded_messages
  end

  private

  def parse_interestings_from(messages)
    messages.each do |message|
      message['body'] = message['body'][/\<h2\>Interestings\<\/h2\>\s*([\S\s]*?)(\<h2\>Events\<\/h2\>|----------)/, 1].strip
    end
  end

end


