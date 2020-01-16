class CreateUserDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :user_details do |t|
      t.string :encrypted_email
      t.string :encrypted_password_digest
      t.timestamps null: false
    end
  end
end
