class CreatePointOfServices < ActiveRecord::Migration[5.1]
  def change
    create_table :point_of_services do |t|
      t.string :nom
      t.string :email

      t.timestamps
    end
  end
end
