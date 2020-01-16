class AddActivationToOrganismes < ActiveRecord::Migration[5.1]
  def change
  	add_column :organismes, :est_actif, :boolean, default: true
  	add_column :organismes, :activated, :boolean, default: true
    add_column :organismes, :activated_at, :datetime
  end
end
