class CreateFuncionariosServicos < ActiveRecord::Migration[6.0]
  def change
    create_table :funcionarios_servicos do |t|
      t.references :funcionario, null: false, foreign_key: true
      t.references :servico, null: false, foreign_key: true

      t.timestamps
    end
  end
end
