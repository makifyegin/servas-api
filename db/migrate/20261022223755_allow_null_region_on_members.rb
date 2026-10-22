class AllowNullRegionOnMembers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :members, :region_id, true
  end
end
