class AddActivationToOrganismeReferents < ActiveRecord::Migration[5.1]
  def change

  	add_column :organisme_referents, :est_actif, :boolean, default: true
  	add_column :organisme_referents, :activated, :boolean, default: true
    add_column :organisme_referents, :activated_at, :datetime
  end
end
