class AddInformationToReferents < ActiveRecord::Migration[5.1]
  def change
  	add_column :referents, :tel_bureau, :string
  	add_column :referents, :tel_cell, :string
  	add_column :referents, :fax, :string
  end
end
