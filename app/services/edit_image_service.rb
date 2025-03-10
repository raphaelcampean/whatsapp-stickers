require 'rmagick'
require 'aws-sdk-s3'

class EditImageService
  MINIO_ENDPOINT = "https://141f-2804-14d-5c21-af0c-6c0a-7891-d726-4e8.ngrok-free.app"
  MINIO_BUCKET = "whatsapp-stickers" # Nome do bucket atualizado
  MINIO_ACCESS_KEY = "admin"
  MINIO_SECRET_KEY = "secretpassword"

  def initialize(image)
    @image = image
  end

  def call
    upload_to_minio(process_image)
  end

  private

  def process_image
    img = Magick::Image.read(@image.path).first
    img = img.resize_to_fill(512, 512)
    
    output_path = Rails.root.join('public', 'uploads', 'stickers', "processed_#{SecureRandom.hex}.webp")

    img.format = "WEBP"

    img.write(output_path.to_s)

    output_path
  end

  def upload_to_minio(file_path)
    s3_client = Aws::S3::Client.new(
      endpoint: MINIO_ENDPOINT,
      access_key_id: MINIO_ACCESS_KEY,
      secret_access_key: MINIO_SECRET_KEY,
      force_path_style: true, # Obrigatório para MinIO
      region: 'us-east-1'
    )

    file_name = "stickers/#{File.basename(file_path)}"

    # Envia a imagem para o MinIO
    s3_client.put_object(
      bucket: MINIO_BUCKET,
      key: file_name,
      body: File.open(file_path, 'rb'),
      acl: 'public-read',
      content_type: 'image/webp'
    )

    # Retorna a URL pública da imagem
    "#{MINIO_ENDPOINT}/#{MINIO_BUCKET}/#{file_name}"
  end
end
