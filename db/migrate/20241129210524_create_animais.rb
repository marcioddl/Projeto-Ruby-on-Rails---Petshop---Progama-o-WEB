class CreateAnimais < ActiveRecord::Migration[7.2]
  def change
    create_table :animais do |t|
      t.string :nome
      t.string :especie
      t.string :raca
      t.integer :idade
      t.references :dono, null: false, foreign_key: true

      t.timestamps
    end
  end
end
