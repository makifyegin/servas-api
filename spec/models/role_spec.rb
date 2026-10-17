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
end
