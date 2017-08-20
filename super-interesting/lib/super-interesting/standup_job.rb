require "net/http"
require "json"
require "base64"

class StandupJob
  
  def run(before:, after:)
    messages = get_standup_messages(before: before, after: after)
    decode(messages)
    parse_interestings_from(messages)
    messages
  end

  def get_standup_messages(before:, after:)
    response = http_client(list_messages_uri(before: before, after: after)).start do |http|
      http.request(get_list_of_standup_messages)
    end

    raise 'Request to Gmail API responded with 401 Unauthorized' if response.code == '401'
    return [] if JSON.parse(response.body)['resultSizeEstimate'] == 0

    messages = JSON.parse(response.body)['messages']
    messages.each do |message|
      response = http_client(get_message_uri(message['id'])).start do |http|
        http.request(get_contents_of_message(message['id']))
      end

      message['body'] = JSON.parse(response.body)['payload']['parts'][1]['body']['data']

      JSON.parse(response.body)['payload']['headers'].each do |header|
        message['location'] = header['value'][/.*\[Standup\]\[(.*)\]/, 1] if header['name'] == 'Subject'
      end
    end
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
      message['body'] = message['body'][/(\<h2\>Interestings\<\/h2\>[\S\s]*?)(\<h2\>Events\<\/h2\>|----------)/, 1].strip
    end
  end

  def get_list_of_standup_messages
    request = Net::HTTP::Get.new(list_messages_uri)
    request['Authorization'] = 'Bearer ya29.GlutBKBdDwY6swfLzZO5oKP67A4T29P_APAu9ZOncjDVfUz_rDGEz2So1Gw61sYJIW2QfE40YbL11VdK6qzt3AQENFIJf5fpoc2jzJqlTceP5cCZSil8jvV_PYwt'
    request
  end
  
  def get_contents_of_message(id)
    request = Net::HTTP::Get.new(get_message_uri(id))
    request['Authorization'] = 'Bearer ya29.GlutBKBdDwY6swfLzZO5oKP67A4T29P_APAu9ZOncjDVfUz_rDGEz2So1Gw61sYJIW2QfE40YbL11VdK6qzt3AQENFIJf5fpoc2jzJqlTceP5cCZSil8jvV_PYwt'
    request
  end

  def http_client(uri)
    @http_client ||= begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http
    end
  end

  def list_messages_uri(before: (Time.now + 3600*24).strftime("%Y/%m/%d"), after: (Time.now).strftime("%Y/%m/%d"))
    @list_messages_uri ||= begin
      URI("https://www.googleapis.com/gmail/v1/users/shoabeshariff@gmail.com/messages?q='subject:Standup%20after:#{after}%20before:#{before}'")
    end
  end
  
  def get_message_uri(id)
    URI("https://www.googleapis.com/gmail/v1/users/shoabeshariff@gmail.com/messages/#{id}?format=full")
  end

end


