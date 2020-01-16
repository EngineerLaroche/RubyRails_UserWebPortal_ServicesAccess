class AddActivationToReferents < ActiveRecord::Migration[5.1]
  def change
    add_column :referents, :activated, :boolean, default: true
    add_column :referents, :activated_at, :datetime
  end
end
