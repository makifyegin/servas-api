require "rails_helper"

RSpec.describe Region::Create do
  let(:country) { create(:country) }
  it "creates the region" do
    response = Region::Create.call(region_params: { name: "West Midlands", country_id: country.id })
    expect(response).to be_success
    expect(Region.find_by(name: "West Midlands")).not_to be_nil
    expect(response[:region][:name]).to eq "West Midlands"
  end

  it "returns an error when the name is blank" do
    response = Region::Create.call(region_params: { name: "", country_id: country.id })
    expect(response).not_to be_success
  end
end
