class FotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # dimençao da imagem
  process resize_to_fit: [ 800, 800 ]  

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"# dieretorio da imagem
  end

  def extension_white_list
    %w[jpg jpeg gif png] #frmatos aceitos
  end

  def filename
    if original_filename.present?
      "#{mounted_as}.#{file.extension}"#nome da foto que vai ser salvo
    end
  end
end
