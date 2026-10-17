class AddPlaceToRoles < ActiveRecord::Migration[8.1]
  def change
    add_reference :roles, :group,  foreign_key: true
    add_reference :roles, :region,  foreign_key: true
  end
end
