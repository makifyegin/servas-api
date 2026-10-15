require "rails_helper"

RSpec.describe Region::Update do
  let(:country) { create(:country) }
  let(:region) { create(:region, name: "East Midlands", country_id: country.id) }
  it "update the region" do
    response = Region::Update.call(region:, region_params: { name: "Yorkshire", country_id: country.id })
    expect(response).to be_success
    expect(Region.find_by(name: "Yorkshire")).not_to be_nil
    expect(response[:region][:name]).to eq "Yorkshire"
  end

  it "returns an error when the name is blank" do
    response = Region::Update.call(region:, region_params: { name: "", country_id: country.id })
    expect(response).not_to be_success
    expect(region.reload.name).to eq("East Midlands")
  end
end
