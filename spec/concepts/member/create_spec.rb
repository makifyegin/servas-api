# frozen_string_literal: true


require "rails_helper"

RSpec.describe Member::Create do
  let(:region) { create(:region) }
  it "creates the amiko member" do
    response = Member::Create.call(member_params: { hydra_sub: "123" })
    expect(Member.find_by(hydra_sub: "123")).to eq(response[:member])
    expect(response).to be_success
  end
  it "returns an error when there's no user" do
    response = Member::Create.call(member_params: { hydra_sub: nil })
    expect(response).to be_failure
    expect(Member.find_by(hydra_sub: "")).to be_nil
  end
  end
