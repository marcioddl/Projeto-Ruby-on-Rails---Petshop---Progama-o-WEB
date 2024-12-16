class CreateDonos < ActiveRecord::Migration[7.2]
  def change
    create_table :donos do |t|
      t.string :nome
      t.string :email, null: false
      t.string :telefone
      t.string :cpf
      t.endereco :endereco
      t.timestamps
    end

    add_index :donos, :cpf, unique: true
  end
end
