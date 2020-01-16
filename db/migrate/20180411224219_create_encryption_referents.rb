class CreateEncryptionReferents < ActiveRecord::Migration[5.1]
  def change
    create_table :encryption_referents do |t|

      	t.string :encrypted_email
      	t.string :encrypted_tel_bureau
      	t.string :encrypted_tel_cell
      	t.string :encrypted_fax
      	t.string :encrypted_nom
      	t.string :encrypted_prenom
      	t.string :encrypted_titre
      	t.timestamps null: false
    end
  end
end
