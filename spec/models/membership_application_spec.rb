# frozen_string_literal: true

require "rails_helper"

RSpec.describe MembershipApplication, type: :model do
  it "is valid with a member and a region" do
    expect(build(:membership_application)).to be_valid
  end

  it "starts as applied" do
    expect(described_class.new.status).to eq("applied")
  end

  it "is not valid when the member already has an open application" do
    first = create(:membership_application)
    second = build(:membership_application, member: first.member)
    expect(second).not_to be_valid
  end

  it "is valid when the member's earlier application was canceled" do
    first = create(:membership_application, status: "canceled")
    second = build(:membership_application, member: first.member)
    expect(second).to be_valid
  end
end