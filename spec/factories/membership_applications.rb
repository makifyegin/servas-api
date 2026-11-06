# frozen_string_literal: true

FactoryBot.define do
  factory :membership_application do
    member
    region
    # status: the database default "applied"
  end
end