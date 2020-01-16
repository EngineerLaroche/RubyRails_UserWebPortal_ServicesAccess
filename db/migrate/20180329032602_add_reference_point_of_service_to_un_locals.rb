class AddReferencePointOfServiceToUnLocals < ActiveRecord::Migration[5.1]
  def change
    add_reference :un_locals, :point_of_services, foreign_key: true
  end
end
