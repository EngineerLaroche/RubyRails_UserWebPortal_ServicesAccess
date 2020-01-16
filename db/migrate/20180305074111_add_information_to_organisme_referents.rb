class AddInformationToOrganismeReferents < ActiveRecord::Migration[5.1]
  def change

  	add_column :organisme_referents, :tel, :string
    add_column :organisme_referents, :fax, :string
    add_column :organisme_referents, :email, :string
    add_column :organisme_referents, :website, :string

  end
end
