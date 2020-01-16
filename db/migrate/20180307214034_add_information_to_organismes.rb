class AddInformationToOrganismes < ActiveRecord::Migration[5.1]
  def change
  	add_column :organismes, :tel, :string
  	add_column :organismes, :fax, :string
  end
end
