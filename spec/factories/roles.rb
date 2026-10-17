# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    user_id { SecureRandom.uuid }
    role { "member" }
    group { association :group }
  end
end
