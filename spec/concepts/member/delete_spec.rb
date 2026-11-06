# frozen_string_literal: true

require "rails_helper"

RSpec.describe Member::Delete do
  let(:member) { create(:member) }
  let(:membership_application) { create(:membership_application, member: member) }
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
end
