require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:country) { create(:country) }
  it "has a valid factory" do
    region = build(:region)
    expect(region).to be_valid
  end
  it "is not valid without name" do
    region = build(:region, name: nil)
    expect(region).not_to be_valid
  end

  it "belongs to country" do
    country = create(:country)
    region = create(:region, country: country)
    expect(region.country).to eq(country)
  end

  it "is not a valid without country" do
    region = build(:region, country: nil)
    expect(region).not_to be_valid
  end

  it "a region with members can't be deleted" do
    region = create(:region)
    member = create(:member, region: region)
    region.destroy
    expect(Region.exists?(region.id)).to be true
  end

  it "allows the same region name in different countries" do
    region1 = create(:region, name: "York", country: create(:country))
    region2 = build(:region, name: "York", country: create(:country))
    expect(region2).to be_valid
  end
  it "doesn't allow the same region name in same country" do
    create(:region, name: "York", country: country)
    region2 = build(:region, name: "York", country: country)
    expect(region2).not_to be_valid
  end
end
