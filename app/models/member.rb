class Member < ApplicationRecord
  belongs_to :region, optional: true

  enum :status, {
    amiko: "amiko",
    applied: "applied",
    interview_booked: "interview_booked",
    payment_pending: "payment_pending",
    consent_pending: "consent_pending",
    approved: "approved",
    rejected: "rejected"
  }

  validates :hydra_sub, presence: true, uniqueness: true
  validates :region, presence: true, unless: :amiko?
end
