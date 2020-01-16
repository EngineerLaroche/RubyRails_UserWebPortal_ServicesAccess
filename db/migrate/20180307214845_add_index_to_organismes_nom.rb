class AddIndexToOrganismesNom < ActiveRecord::Migration[5.1]
  def change
  	add_index :organismes, :nom, unique: true
  end
end
