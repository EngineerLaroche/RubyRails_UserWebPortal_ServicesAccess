class AddAdresseToOrganismes < ActiveRecord::Migration[5.1]
  def change
  	add_column :organismes, :no_civique, :string
  	add_column :organismes, :rue, :string
  	add_column :organismes, :ville, :string
  	add_column :organismes, :province, :string
  	add_column :organismes, :code_postal, :string
  end
end
