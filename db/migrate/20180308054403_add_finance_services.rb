class AddFinanceServices < ActiveRecord::Migration[5.1]
  def change
  	add_column :services, :tarification_parent, :integer
  	add_column :services, :tarification_cisss, :integer
  end
end
