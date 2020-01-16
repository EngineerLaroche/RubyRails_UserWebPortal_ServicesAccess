class CreateEncryptionServices < ActiveRecord::Migration[5.1]
  def change
    create_table :encryption_services do |t|

      t.string :encrypted_nom
      t.string :encrypted_description
      t.string :encrypted_tarification_parent
      t.string :encrypted_tarification_cisss
      t.timestamps null: false
    end
  end
end
