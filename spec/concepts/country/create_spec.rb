# frozen_string_literal: true


require "rails_helper"

RSpec.describe Country::Create do
  let(:group) { create(:group) }
  it "creates the country" do
    response = Country::Create.call(country_params: { name: "Ireland", group_id: group.id })
    expect(Country.find_by(name: "Ireland")).to eq(response[:country])
    expect(response).to be_success
  end
  it "returns an error when the name is blank" do
    response = Country::Create.call(country_params: { name: "", group_id: group.id })
    expect(response).to be_failure
    expect(Country.find_by(name: "")).to be_nil
  end
  end
