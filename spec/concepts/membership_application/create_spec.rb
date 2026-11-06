# frozen_string_literal: true

require "rails_helper"

RSpec.describe MembershipApplication::Create do
  let(:member) { create(:member) }
  let(:region) { create(:region) }

  it "creates an applied membership application" do
    response = described_class.call(member:, region_id: region.id)

    expect(response).to be_success
    expect(response[:membership_application].status).to eq("applied")
    expect(response[:membership_application].member).to eq(member)
  end

  it "returns an error when the region does not exist" do
    response = described_class.call(member:, region_id: 0)
    expect(response).to be_failure
  end
end
