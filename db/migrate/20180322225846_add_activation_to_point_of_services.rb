class AddActivationToPointOfServices < ActiveRecord::Migration[5.1]
  def change

  	add_column :point_of_services, :activated, :boolean, default: true
    add_column :point_of_services, :activated_at, :datetime
  end
end
