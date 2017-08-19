require 'net/http'
require 'json'

class GetAllInterestingsUseCase

  def get_todays_standup_messages
    response = http_client.start do |http|
      http.request(request)
    end
    JSON.parse(response.body)
  end

  private

  def request
    @request ||= begin
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = 'Bearer ya29.GlusBIfSKOrBvMkJ0yEL05oJaK4jQGOZNl3Af564jcVAI-CE2dxaK9rYCA1LB1fu29L2k7Hsc9VUF4ToE-hOFVq0QfTht0vbjA6Kn1ETHg75Qd49FNvs4tqNirk5'
      request
    end
  end

  def http_client
    @http_client ||= begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http
    end
  end

  def uri
    @uri ||= begin
      URI("https://www.googleapis.com/gmail/v1/users/shoabeshariff@gmail.com/messages?maxResults=3&q='subject:Standup'")
    end
  end

end
