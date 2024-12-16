
class Animal < ApplicationRecord
  self.table_name = "animais" 
  mount_uploader :foto, FotoUploader

  def foto_thumb
    foto.thumbnail ? foto.thumb.url : foto.url
  end

  belongs_to :dono
  has_many :atendimentos, dependent: :destroy

  validates :nome, presence: true
  validates :especie, presence: true
  validates :raca, presence: true
  validates :idade, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
