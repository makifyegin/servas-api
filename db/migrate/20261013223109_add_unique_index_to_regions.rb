class AddUniqueIndexToRegions < ActiveRecord::Migration[8.1]
  def change
    add_index :regions, [ :name, :country_id ], unique: true
  end
end
