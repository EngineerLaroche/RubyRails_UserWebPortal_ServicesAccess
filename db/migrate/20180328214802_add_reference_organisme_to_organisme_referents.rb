class AddReferenceOrganismeToOrganismeReferents < ActiveRecord::Migration[5.1]
  def change
    add_reference :organisme_referents, :organismes, foreign_key: true
  end
end
