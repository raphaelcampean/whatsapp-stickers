require 'rmagick'

class EditImageService
  def initialize(image)
    @image = image
  end

  def call
    # Chama o método de classe para criar a imagem
    self.class.create_image(@image)
  end

  # Método de classe para processar a imagem
  def self.create_image(image)
    # Lê a imagem e aplica o resize
    img = Magick::Image.read(image.path).first
    img = img.resize_to_fill(512, 512)

    # Define o caminho do arquivo de saída
    output_path = Rails.root.join('public', 'uploads', 'stickers', "processed_#{SecureRandom.hex}.webp")

    # Define o formato da imagem como WebP
    img.format = "WEBP"

    # Salva a imagem processada
    img.write(output_path.to_s)

    # Gera e retorna a URL pública da imagem
    public_url = generate_public_url(output_path)

    # Retorna a URL pública
    public_url
  end

  private

  # Gera a URL pública da imagem
  def self.generate_public_url(output_path)
    # Caminho relativo dentro da pasta public
    relative_path = "/uploads/stickers/#{output_path.basename.to_s}"

    # URL pública completa usando o domínio da aplicação
    public_url = Rails.application.routes.url_helpers.root_url(host: 'localhost', port: 3000).chomp('/') + relative_path

    public_url
  end
end
