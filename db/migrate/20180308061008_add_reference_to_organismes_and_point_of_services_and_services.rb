class AddReferenceToOrganismesAndPointOfServicesAndServices < ActiveRecord::Migration[5.1]
  def change
  	add_reference :point_of_services, :organismes, foreign_key: true
  	add_reference :Services, :point_of_services, foreign_key: true
  end
end
