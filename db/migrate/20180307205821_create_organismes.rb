class CreateOrganismes < ActiveRecord::Migration[5.1]
  def change
    create_table :organismes do |t|
      t.string :nom
      t.string :email

      t.timestamps
    end
  end
end
