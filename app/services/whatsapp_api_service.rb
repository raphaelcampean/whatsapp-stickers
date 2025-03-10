class WhatsappApiService
  include HTTParty
  base_uri 'https://api.chat-api.com/instance'

  def initialize
    @options = { query: { token: ENV['CHAT_API_TOKEN'] } }
  end
end
