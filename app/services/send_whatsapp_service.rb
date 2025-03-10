require "twilio-ruby"

class SendWhatsappService
  def initialize(to, image_url)
    @to = "whatsapp:#{to}"
    @image_url = image_url
  end

  def call
    client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

    message = client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: @to,
      body: "Aqui está sua figurinha!",
      media_url: [@image_url] # URL da imagem no MinIO
    )

    message.sid
  end
end
