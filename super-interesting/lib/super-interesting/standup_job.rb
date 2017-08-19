require 'net/http'
require 'json'

class StandupJob

  def get_todays_standup_messages
    response = http_client(list_messages_uri).start do |http|
      http.request(get_list_of_standup_messages)
    end

    messages = JSON.parse(response.body)['messages']
    messages.each do |message|
      response = http_client(get_message_uri(message['id'])).start do |http|
        http.request(get_contents_of_message(message['id']))
      end
      message['body'] = JSON.parse(response.body)['payload']['parts'][1]['body']['data']
    end
    messages
  end

  private

  def get_list_of_standup_messages
    request = Net::HTTP::Get.new(list_messages_uri)
    request['Authorization'] = 'Bearer s0Me\B3Ar3rt0kenVaLu3'
    request
  end
  
  def get_contents_of_message(id)
    request = Net::HTTP::Get.new(get_message_uri(id))
    request['Authorization'] = 'Bearer s0Me\B3Ar3rt0kenVaLu3'
    request
  end

  def http_client(uri)
    @http_client ||= begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http
    end
  end

  def list_messages_uri
    @list_messages_uri ||= begin
      URI("https://www.googleapis.com/gmail/v1/users/shoabeshariff@gmail.com/messages?maxResults=3&q='subject:Standup'")
    end
  end
  
  def get_message_uri(id)
    URI("https://www.googleapis.com/gmail/v1/users/shoabeshariff@gmail.com/messages/#{id}?format=full")
  end

end


