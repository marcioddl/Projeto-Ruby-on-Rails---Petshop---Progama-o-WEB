
   class Documento < ApplicationRecord
  mount_uploader :arquivo, ArquivoUploader

  validates :nome, presence: true
   end
