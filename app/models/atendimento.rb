class Atendimento < ApplicationRecord
  belongs_to :animal
  belongs_to :funcionario
  belongs_to :servico

  before_create :set_default_date

  private

  def set_default_date
    self.data ||= Time.current
  end
end
