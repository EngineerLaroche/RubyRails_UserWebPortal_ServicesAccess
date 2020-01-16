class AddSupressionToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :supression, :boolean, default: true
  end
end
