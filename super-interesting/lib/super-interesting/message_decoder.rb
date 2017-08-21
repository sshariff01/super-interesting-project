require "base64"

class MessageDecoder

  def decode(messages)
    messages.each do |message|
      message['body'] = Base64.urlsafe_decode64(message['body'])
    end
    messages
  end

end