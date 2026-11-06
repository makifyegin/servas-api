# frozen_string_literal: true

require "rails_helper"

RSpec.describe MembershipApplication::Cancel do
  let(:membership_application) { create(:membership_application) }

  it "cancels the membership application" do
    response = described_class.call(membership_application:)

    expect(response).to be_success
    expect(response[:membership_application]).to eq(membership_application)
    expect(membership_application.reload.status).to eq("canceled")
  end

  it "keeps the canceled row" do
    described_class.call(membership_application:)
    expect(MembershipApplication.find_by(id: membership_application.id)).to be_present
  end

  it "returns an error when the application cannot be saved" do
    allow(membership_application).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(membership_application))

    response = described_class.call(membership_application:)
    expect(response).to be_failure
    expect(response[:error]).to start_with("Error canceling membership application:")
    expect(membership_application.reload.status).to eq("applied")
  end
end
