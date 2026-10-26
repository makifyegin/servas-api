class CreateMembershipApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :membership_applications do |t|
      t.references :member, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.string :status, default: "applied", null: false

      t.timestamps
    end
  end
end
