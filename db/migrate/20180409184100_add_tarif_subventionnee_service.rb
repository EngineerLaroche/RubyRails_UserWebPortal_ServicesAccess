class AddTarifSubventionneeService < ActiveRecord::Migration[5.1]
  def change
  	add_column :services, :est_subventionnee, :boolean, default: false
  end
end
