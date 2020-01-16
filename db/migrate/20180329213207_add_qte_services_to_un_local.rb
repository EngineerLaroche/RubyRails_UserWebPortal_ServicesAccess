class AddQteServicesToUnLocal < ActiveRecord::Migration[5.1]
  def change
  	add_column :un_locals, :qte_services, :string
  end
end
