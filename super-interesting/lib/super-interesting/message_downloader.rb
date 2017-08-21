require "net/http"
require "json"

class MessageDownloader

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

  def get_list_of_standup_messages
    request = Net::HTTP::Get.new(list_messages_uri)
    request['Authorization'] = 'Bearer ya29.GluuBIDoxu7UPhSIw6E2stE31BzOhB4F1Nom30BZokeBhmBhYnXo3xu3FxITGGj-dmieLLMddDwZr_mN6zf4yXvRxrlWelgRAG6Jx1Td1WG6ThGZR0_Sl1ToAhFN'
    request
  end

  def get_contents_of_message(id)
    request = Net::HTTP::Get.new(get_message_uri(id))
    request['Authorization'] = 'Bearer ya29.GluuBIDoxu7UPhSIw6E2stE31BzOhB4F1Nom30BZokeBhmBhYnXo3xu3FxITGGj-dmieLLMddDwZr_mN6zf4yXvRxrlWelgRAG6Jx1Td1WG6ThGZR0_Sl1ToAhFN'
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
