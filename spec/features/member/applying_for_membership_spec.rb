# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Applying for membership", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:region) { create(:region, name: "West Midlands") }
  before { stub_authenticated_user(sub: "akif") }
  it "responds 201 Created with an applied membership application when the user is an amiko" do
    create(:member, hydra_sub: "akif")
    post "/api/me/membership_application", params: { region_id: region.id }, headers: headers

    expect(response).to have_http_status(:created)
    expect(response.parsed_body["status"]).to eq("applied")
    expect(response.parsed_body["region_id"]).to eq(region.id)
  end

  it "responds 403 Forbidden when the user is already a member" do
    create(:member, hydra_sub: "akif", status: "member", region:)

    post "/api/me/membership_application", params: { region_id: region.id }, headers: headers

    expect(response).to have_http_status(:forbidden)
  end



end
