FactoryBot.define do
  factory :member do
    region
    hydra_sub { SecureRandom.uuid }
  end
end