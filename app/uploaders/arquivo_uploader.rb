
  class ArquivoUploader < CarrierWave::Uploader::Base
  # Escolhe o tipo de armazenamento: no sistema de arquivos (padrão)
  storage :file

  # Define o diretório onde os arquivos serão armazenados
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Método para processar arquivos enviados como Base64
  def cache!(new_file)
    if new_file.is_a?(String) && new_file.start_with?("data:")
      # Cria um arquivo temporário para armazenar o conteúdo decodificado
      tempfile = Tempfile.new
      tempfile.binmode
      tempfile.write(Base64.decode64(new_file.split(",").last))
      tempfile.rewind
      super(tempfile) # Processa o arquivo temporário
      tempfile.close
      tempfile.unlink
    else
      super
    end
  end

    # Lista de extensões permitidas (opcional)
    # def extension_allowlist
    #   %w(jpg jpeg gif png pdf doc docx)
    # end

    # Sobrescreve o nome do arquivo carregado (opcional)
    # def filename
    #   "custom_filename_#{original_filename}" if original_filename
    # end
  end
