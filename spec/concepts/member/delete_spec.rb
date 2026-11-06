# frozen_string_literal: true

require "rails_helper"

RSpec.describe Member::Delete do
  let(:member) { create(:member) }
  let(:membership_application) { create(:membership_application, member: member) }

  before { stub_login_deletion }

  it "deletes the member" do
    response = Member::Delete.call(member_id: member.id)
    expect(Member.find_by(id: member.id)).to be_nil
    expect(response).to be_success
  end

  it "deletes member application too" do
    membership_application
    response = Member::Delete.call(member_id: member.id)
    expect(Member.find_by(id: member.id)).to be_nil
    expect(MembershipApplication.find_by(id: membership_application.id)).to be_nil
    expect(response).to be_success
  end

  it "revokes the member's Hydra sessions" do
    Member::Delete.call(member_id: member.id)
    expect(HydraAdminApiClient).to have_received(:revoke_sessions).with(subject: member.hydra_sub)
  end

  it "deletes the member's Kratos identity" do
    Member::Delete.call(member_id: member.id)
    expect(KratosAdminApiClient).to have_received(:delete_identity).with(id: member.hydra_sub)
  end

  it "keeps the member and does not touch Kratos when Hydra fails" do
    allow(HydraAdminApiClient).to receive(:revoke_sessions).and_raise(Faraday::ServerError)

    expect { Member::Delete.call(member_id: member.id) }.to raise_error(Faraday::ServerError)
    expect(Member.find_by(id: member.id)).to eq(member)
    expect(KratosAdminApiClient).not_to have_received(:delete_identity)
  end

  it "keeps the member and their applications when Kratos fails" do
    membership_application
    allow(KratosAdminApiClient).to receive(:delete_identity).and_raise(Faraday::ServerError)

    expect { Member::Delete.call(member_id: member.id) }.to raise_error(Faraday::ServerError)
    expect(Member.find_by(id: member.id)).to eq(member)
    expect(MembershipApplication.find_by(id: membership_application.id)).to eq(membership_application)
  end
end
