require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:servas_international) { create(:servas_international) }
  it "has valid factory" do
    group = build(:group)
    expect(group).to be_valid
  end
  it "can have no parent (Servas International)" do
    expect(servas_international).to be_valid
    non_servas_international_group = build(:group, name: "Non-Servas International", parent_id: nil)
    expect(non_servas_international_group).not_to be_valid
  end
  it "can have a parent group" do
    servas_britain_group = create(:group, name: "Servas Britain", parent_id: servas_international.id)
    expect(servas_britain_group).to be_valid
    expect(servas_britain_group.parent_id).to eq servas_international.id
  end
  it "lists its child groups" do
    servas_britain_group = create(:group, name: "Servas Britain", parent_id: servas_international.id)
    expect(servas_international.children).to include(servas_britain_group)
  end
  it "has the regions of its countries" do
    group = create(:group)
    uk = create(:country, name: "United Kingdom", group:)
    ireland = create(:country, name: "Ireland", group:)
    west_midlands = create(:region, country: uk)
    dublin = create(:region, country: ireland)

    expect(group.regions).to contain_exactly(west_midlands, dublin)
  end
end
