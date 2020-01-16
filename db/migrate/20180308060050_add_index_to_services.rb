class AddIndexToServices < ActiveRecord::Migration[5.1]
  def change
  	add_index :services, :nom, unique: true
  end
end
