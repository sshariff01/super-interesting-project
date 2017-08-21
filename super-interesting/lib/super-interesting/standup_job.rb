require "net/http"
require "json"
require "base64"

class StandupJob
  attr_reader :message_downloader
  
  def initialize(message_downloader:)
    @message_downloader = message_downloader
  end
  
  def run(before:, after:)
    messages = message_downloader.get_standup_messages(before: before, after: after)
    decode(messages)
    parse_interestings_from(messages)
    messages
  end

  private

  def decode(messages)
    messages.each do |message|
      message['body'] = Base64.urlsafe_decode64(message['body'])
    end
  end

  def parse_interestings_from(messages)
    messages.each do |message|
      message['body'] = message['body'][/\<h2\>Interestings\<\/h2\>\s*([\S\s]*?)(\<h2\>Events\<\/h2\>|----------)/, 1].strip
    end
  end

end


