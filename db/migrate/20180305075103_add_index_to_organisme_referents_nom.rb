class AddIndexToOrganismeReferentsNom < ActiveRecord::Migration[5.1]
  def change
  	add_index :organisme_referents, :nom, unique: true
  end
end
