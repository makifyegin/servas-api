class Member < ApplicationRecord
  belongs_to :region, optional: true
  has_many :membership_applications, dependent: :destroy

  enum :status, {
    amiko: "amiko",
    member: "member"
  }

  validates :hydra_sub, presence: true, uniqueness: true
  validates :region, presence: true, unless: :amiko?
end
