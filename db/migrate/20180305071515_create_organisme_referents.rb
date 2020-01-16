class CreateOrganismeReferents < ActiveRecord::Migration[5.1]
  def change
    create_table :organisme_referents do |t|
    
      t.string :nom
      t.string :courriel
      t.string :site_web
      
      t.timestamps
    end
  end
end
