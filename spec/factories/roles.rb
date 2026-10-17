FactoryBot.define do
  factory :role do
    user_id { SecureRandom.uuid }
    role { "national_secretary" }
    group { association :group }

    trait :si_admin do
      role { "si_admin" }
      group { association :servas_international }
    end
  end
end
