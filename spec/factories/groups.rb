FactoryBot.define do
  factory :servas_international, class: "Group" do
    name { "Servas International" }
    parent { nil }
    initialize_with { Group.find_or_create_by(name: name, parent_id: nil) }
  end

  factory :group do
    name { "Servas Britain & Ireland" }
    parent { association :servas_international }
  end
end
