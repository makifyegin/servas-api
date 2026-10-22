class RemoveNameFromMembers < ActiveRecord::Migration[8.1]
  def change
    remove_column :members, :name, :string
  end
end
