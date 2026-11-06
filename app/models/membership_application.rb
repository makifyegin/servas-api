# frozen_string_literal: true

class MembershipApplication < ApplicationRecord
  OPEN_STATUSES = %w[applied interview_booked payment_pending consent_pending].freeze
  belongs_to :member
  belongs_to :region

  enum :status, {
    applied: "applied",
    interview_booked: "interview_booked",
    payment_pending: "payment_pending",
    consent_pending: "consent_pending",
    approved: "approved",
    rejected: "rejected",
    canceled: "canceled"
  }

  validate :only_one_open_application, on: :create

  private

  def only_one_open_application
    return if member.nil?
    return unless MembershipApplication.where(member_id:, status: OPEN_STATUSES).exists?

    errors.add(:base, "already has an open membership application")
  end
end
