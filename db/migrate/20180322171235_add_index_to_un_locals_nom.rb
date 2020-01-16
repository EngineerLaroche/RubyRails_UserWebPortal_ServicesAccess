class AddIndexToUnLocalsNom < ActiveRecord::Migration[5.1]
  def change
  	add_index :un_locals, :nom, unique: true
  end
end
