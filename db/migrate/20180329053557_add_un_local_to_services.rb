class AddUnLocalToServices < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :un_locals, foreign_key: true
  end
end
