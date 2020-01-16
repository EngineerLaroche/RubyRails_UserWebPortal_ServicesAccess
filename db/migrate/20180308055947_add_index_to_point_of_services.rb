class AddIndexToPointOfServices < ActiveRecord::Migration[5.1]
  def change
  	add_index :point_of_services, :nom, unique: true
  end
end
