class Servico < ApplicationRecord
  has_many :atendimentos, dependent: :destroy

  validates :nome, presence: true
  validates :preco, numericality: { greater_than: 0 }, presence: true
  validates :descricao, presence: true
end
