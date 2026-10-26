class MembershipApplication < ApplicationRecord
  belongs_to :member
  belongs_to :region

  enum :status, {
    applied: "applied",
    interview_booked: "interview_booked",
    payment_pending: "payment_pending",
    consent_pending: "consent_pending",
    approved: "approved",
    rejected: "rejected",
    cancelled: "cancelled"
  }

end
