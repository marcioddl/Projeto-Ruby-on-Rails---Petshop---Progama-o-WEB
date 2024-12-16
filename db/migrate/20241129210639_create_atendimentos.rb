class CreateAtendimentos < ActiveRecord::Migration[7.2]
  def change
    create_table :atendimentos do |t|
      t.date :data
      t.text :descricao
      t.references :animal, null: false, foreign_key: { to_table: :animais }
      t.references :funcionario, null: false, foreign_key: true
      t.references :servico, null: false, foreign_key: true

      t.timestamps
    end
  end
end
