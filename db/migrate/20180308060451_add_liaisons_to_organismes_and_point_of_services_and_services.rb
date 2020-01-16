class AddLiaisonsToOrganismesAndPointOfServicesAndServices < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :point_of_services , :organismes
    add_foreign_key :services , :point_of_services
  end
end
