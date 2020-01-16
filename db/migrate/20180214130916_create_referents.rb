class CreateReferents < ActiveRecord::Migration[5.1]
  def change
    create_table :referents do |t|
      
      t.string :nom
      t.string :prenom
      t.string :titre
      t.string :email

      t.timestamps
    end
  end
end
