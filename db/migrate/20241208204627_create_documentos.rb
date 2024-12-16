class CreateDocumentos < ActiveRecord::Migration[7.2]
  def change
    create_table :documentos do |t|
      t.string :nome
      t.text :descricao
      t.string :arquivo

      t.timestamps
    end
  end
end
