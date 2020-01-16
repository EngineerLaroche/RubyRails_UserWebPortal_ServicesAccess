class AddActivationServices < ActiveRecord::Migration[5.1]
  def change
  	add_column :services, :est_actif, :boolean, default: true
  	add_column :services, :activated, :boolean, default: true
    add_column :services, :activated_at, :datetime
  end
end
