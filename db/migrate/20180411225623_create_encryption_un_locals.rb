class CreateEncryptionUnLocals < ActiveRecord::Migration[5.1]
  def change
    create_table :encryption_un_locals do |t|

      t.string :encrypted_nom
      t.string :encrypted_qte_places
      t.timestamps null: false
    end
  end
end
