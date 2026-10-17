class Role < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :region, optional: true
  validate :exactly_one_place

  enum :role, {
  member: "member",
  admin: "admin",
  owner: "owner"
}

  private
  def exactly_one_place
    return if [ group_id, region_id ].compact.size == 1

    errors.add(:base, "must belong to exactly one group or region")
  end
end
