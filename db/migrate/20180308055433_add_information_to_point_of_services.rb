class AddInformationToPointOfServices < ActiveRecord::Migration[5.1]
  def change
  	add_column :point_of_services, :tel, :string
  	add_column :point_of_services, :fax, :string
  end
end
