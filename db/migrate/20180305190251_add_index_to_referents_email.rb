class AddIndexToReferentsEmail < ActiveRecord::Migration[5.1]
  def change
  	add_index :referents, :email, unique: true
  end
end
