class AddAdresseToPointOfServices < ActiveRecord::Migration[5.1]
  def change
  	add_column :point_of_services, :no_civique, :string
  	add_column :point_of_services, :rue, :string
  	add_column :point_of_services, :ville, :string
  	add_column :point_of_services, :province, :string
  	add_column :point_of_services, :code_postal, :string
  end
end
