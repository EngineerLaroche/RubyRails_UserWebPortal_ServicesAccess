class CreateUnLocals < ActiveRecord::Migration[5.1]
  def change
    create_table :un_locals do |t|

    	t.string :nom
    	t.string :qte_places
      	t.timestamps
    end
  end
end
