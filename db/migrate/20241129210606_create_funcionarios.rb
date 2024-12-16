class CreateFuncionarios < ActiveRecord::Migration[7.2]
  def change
    create_table :funcionarios do |t|
      t.string :nome
      t.string :funcao
      t.string :telefone
      t.string :registro

      t.timestamps
    end
  end
end
