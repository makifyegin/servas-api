require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:group) { create(:group) }
  let(:region) { create(:region) }
  it "is valid with only a group" do
    role = build(:role, group_id: group.id, region_id: nil)
    expect(role).to be_valid
  end
  it "is valid with only a region" do
    region
    expect(region).to be_valid
  end
  it "is not valid with both a group and a region" do
    role = build(:role, group_id: group.id, region_id: region.id)
    expect(role).not_to be_valid
  end
  it "is not valid with no group and no region" do
    role = build(:role, group_id: nil, region_id: nil)
    expect(role).not_to be_valid
  end
  it "is not valid when the same person has the same role in the same place" do
    group = create(:group)
    create(:role, user_id: "jane", role: "national_secretary", group:)
    duplicate = build(:role, user_id: "jane", role: "national_secretary", group:)

    expect(duplicate).not_to be_valid
  end
end
