# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Showing for membership applications", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:region) { create(:region, name: "West Midlands") }

  before { stub_authenticated_user(sub: "akif") }

  it "responds 401 Unauthorized when no token is given" do
    get "/api/me/membership_applications"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK with my applications, newest first" do
    member = create(:member, hydra_sub: "akif")
    old = create(:membership_application, member:, region:, status: "cancelled", created_at: 2.days.ago)
    new = create(:membership_application, member:, region:, created_at: 1.day.ago)

    get "/api/me/membership_applications", headers: headers

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.map { |a| a["id"] }).to eq([new.id, old.id])
  end
end
