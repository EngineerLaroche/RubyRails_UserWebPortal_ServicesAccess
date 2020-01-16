class AddDateEntreeVigueurTarifToService < ActiveRecord::Migration[5.1]
  def change
  	add_column :services, :date_entree_vigueur, :date
  end
end
