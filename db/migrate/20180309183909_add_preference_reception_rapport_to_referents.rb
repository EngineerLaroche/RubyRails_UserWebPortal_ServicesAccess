class AddPreferenceReceptionRapportToReferents < ActiveRecord::Migration[5.1]
  def change
  	add_column :referents, :pref_rapport_1, :string
  	add_column :referents, :pref_rapport_2, :string
  	add_column :referents, :pref_rapport_3, :string
  end
end
