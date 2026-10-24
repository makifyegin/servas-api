# frozen_string_literal: true

require "rails_helper"

RSpec.describe Member::Update do
  let(:group) { create(:group) }
  let(:country) { create(:country, name: "Ireland", group_id: group.id) }
  it "updates the country" do
    response = Country::Update.call(country: country, country_params: { name: "Malawi" })
    expect(response).to be_success
    expect(response[:country][:name]).to eq "Malawi"
    expect(country.reload.name).to_not eq "Ireland"
  end
  it "returns an error when the name is blank" do
    response = Country::Update.call(country: country, country_params: { name: "" })
    expect(response).to_not be_success
  end
end
