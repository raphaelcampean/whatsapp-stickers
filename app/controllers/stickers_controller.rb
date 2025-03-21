class StickersController < ApplicationController
  def index
  end

  def create

    sticker_url = EditImageService.new(params[:image]).call

    # processed_image = File.open(processed_image_path)
    # uploaded_image = ActiveStorage::Blob.create_and_upload!(
    #   io: processed_image,
    #   filename: "processed_image.webp",
    #   content_type: "image/jpeg"
    #   )

    session[:image] = sticker_url
    session[:whatsapp_number] = params[:whatsapp_number]

    redirect_to root_path, notice: "Imagem processada com sucesso!", flash: { image_url: sticker_url }
  end

  def send_to_whatsapp
    SendWhatsappService.new(session[:whatsapp_number], session[:image]).call

    # @client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

    # @client.messages.create(
    #     from: 'whatsapp:+14155238886',
    #     body: 'Olá! Aqui está a imagem que você pediu!',
    #     to: 'whatsapp:+5521992634840'
    # )

    # # puts message.sid
    # # client = Twilio::REST::Client.new

    # # client.messages.create(
    # #   from: "whatsapp:+14155238886",
    # #   body: "Olá! Aqui está a imagem que você pediu!",
    # #   media_url: session[:image],
    # #   to: "whatsapp:#{params[:phone]}"
    # # )

    redirect_to root_path, notice: "Imagem enviada com sucesso!"
  end
end
