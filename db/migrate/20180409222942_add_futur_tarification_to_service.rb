class AddFuturTarificationToService < ActiveRecord::Migration[5.1]
  def change
  	add_column :services, :sera_subventionnee, :boolean, default: false
  	add_column :services, :futur_tarification_parent, :integer
  	add_column :services, :futur_tarification_cisss, :integer
  end
end
