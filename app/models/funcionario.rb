
class Funcionario < ApplicationRecord
  has_many :atendimentos, dependent: :destroy

  validates :nome, presence: true
  validates :funcao, presence: true
  validates :registro, presence: true, uniqueness: true
  validates :telefone, presence: true, numericality: { only_integer: true }, length: { minimum: 11, maximum: 14, message: "deve ter no mínimo 11 dígitos e máximo 14" }
end
