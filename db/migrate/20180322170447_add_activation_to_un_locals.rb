class AddActivationToUnLocals < ActiveRecord::Migration[5.1]
  def change

  	add_column :un_locals, :est_disponible, :boolean, default: true
    add_column :un_locals, :activated, :boolean, default: true
    add_column :un_locals, :activated_at, :datetime
  end
end
