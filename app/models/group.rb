class Group < ApplicationRecord
  has_many :countries
  belongs_to :parent, class_name: "Group", optional: true
  has_many :roles
  has_many :children, class_name: "Group", foreign_key: :parent_id
  validate :only_one_top_group

  private
  def only_one_top_group
    return if parent_id.present?
    return unless Group.where(parent_id: nil).where.not(id: id).exists?
    errors.add(:parent, "must be set (only Servas International has no parent)")
  end
end
