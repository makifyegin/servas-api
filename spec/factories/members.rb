FactoryBot.define do
  factory :member do
    hydra_sub { SecureRandom.uuid }
  end
end
