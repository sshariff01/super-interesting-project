class StandupJob
  attr_reader :message_downloader, :message_decoder, :category_parser
  
  def initialize(message_downloader:, message_decoder:, category_parser:)
    @message_downloader = message_downloader
    @message_decoder = message_decoder
    @category_parser = category_parser
  end
  
  def run(before:, after:)
    messages = message_downloader.get_standup_messages(before: before, after: after)
    decoded_messages = message_decoder.decode(messages)
    parsed_messages = category_parser.parse_out_category(messages: decoded_messages)
    parsed_messages
  end

end


