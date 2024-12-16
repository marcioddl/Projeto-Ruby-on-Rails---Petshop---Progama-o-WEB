class AddFotoToAnimais < ActiveRecord::Migration[7.2]
  def change
    add_column :animais, :foto, :string
  end
end
