# frozen_string_literal: true

require "rails_helper"

RSpec.describe Region::Delete do
  let(:region) { create(:region) }
  let(:member) { create(:member, region:) }
  it "deletes the region" do
    response = Region::Delete.call(country: region.country, region_id: region.id)
    expect(Region.find_by(id: region.id)).to be_nil
    expect(response).to be_success
  end
  it "returns an error when the region has members" do
    member
    response = Region::Delete.call(country: region.country, region_id: region.id)
    expect(Region.find_by(id: region.id)).to_not be_nil
    expect(response).to_not be_success
  end
end
