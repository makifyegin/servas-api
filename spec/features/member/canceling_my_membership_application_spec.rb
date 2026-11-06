# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Canceling my membership application", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:region) { create(:region, name: "West Midlands") }

  before { stub_authenticated_user(sub: "akif") }

  it "responds 401 Unauthorized when no token is given" do
    put "/api/me/membership_application/cancel"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 404 Not Found when the user has not joined yet" do
    put("/api/me/membership_application/cancel", headers:)
    expect(response).to have_http_status(:not_found)
  end

  it "responds 404 Not Found when the member has no open application" do
    create(:member, hydra_sub: "akif")
    put("/api/me/membership_application/cancel", headers:)
    expect(response).to have_http_status(:not_found)
  end

  it "responds 200 OK with a canceled application when the status is applied" do
    member = create(:member, hydra_sub: "akif")
    application = create(:membership_application, member:, region:, status: "applied")
    put("/api/me/membership_application/cancel", headers:)

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["status"]).to eq("canceled")
    expect(application.reload.status).to eq("canceled")
  end

  it "responds 200 OK with a canceled application when the status is interview_booked" do
    member = create(:member, hydra_sub: "akif")
    application = create(:membership_application, member:, region:, status: "interview_booked")
    put("/api/me/membership_application/cancel", headers:)

    expect(response).to have_http_status(:ok)
    expect(application.reload.status).to eq("canceled")
  end

  it "responds 200 OK with a canceled application when the status is payment_pending" do
    member = create(:member, hydra_sub: "akif")
    application = create(:membership_application, member:, region:, status: "payment_pending")
    put("/api/me/membership_application/cancel", headers:)

    expect(response).to have_http_status(:ok)
    expect(application.reload.status).to eq("canceled")
  end

  it "responds 200 OK with a canceled application" do
    member = create(:member, hydra_sub: "akif")
    application = create(:membership_application, member:, region:, status: "consent_pending")
    put("/api/me/membership_application/cancel", headers:)

    expect(response).to have_http_status(:ok)
    expect(application.reload.status).to eq("canceled")
  end

  it "keeps the canceled row so applications can be counted" do
    member = create(:member, hydra_sub: "akif")
    create(:membership_application, member:, region:)
    put("/api/me/membership_application/cancel", headers:)

    expect(MembershipApplication.where(member:).count).to eq(1)
  end

  it "lets the member apply again after canceling" do
    member = create(:member, hydra_sub: "akif")
    create(:membership_application, member:, region:)
    put("/api/me/membership_application/cancel", headers:)
    post("/api/me/membership_application", params: { region_id: region.id }, headers:)

    expect(response).to have_http_status(:created)
    expect(MembershipApplication.where(member:).count).to eq(2)
  end

  it "does not cancel the application of another member" do
    other = create(:member)
    application = create(:membership_application, member: other, region:)
    create(:member, hydra_sub: "akif")
    put("/api/me/membership_application/cancel", headers:)

    expect(application.reload.status).to eq("applied")
  end
end
