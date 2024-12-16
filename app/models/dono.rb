class Dono < ApplicationRecord
  has_many :animals, dependent: :destroy

  validates :nome, presence: true
  validates :telefone, presence: true, numericality: { only_integer: true }, length: { minimum: 11, maximum: 14, message: "deve ter no mínimo 11 dígitos e máximo 14" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :endereco, presence: true
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/, message: "deve ter 11 dígitos" }
end
