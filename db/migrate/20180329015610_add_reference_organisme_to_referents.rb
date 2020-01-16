class AddReferenceOrganismeToReferents < ActiveRecord::Migration[5.1]
  def change
    add_reference :referents, :organismes, foreign_key: true
  end
end
