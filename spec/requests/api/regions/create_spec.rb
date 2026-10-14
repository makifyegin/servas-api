require "rails_helper"

RSpec.describe "POST /api/regions", type: :request do
  let(:country) { create(:country) }
  let(:params) { { region: { name: "West Midlands" }, country_id: country.id } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  it "responds 401 Unauthorized when no token is given" do
    post "/api/regions", params: params
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member1")
      create(:role, user_id: "member1", role: "member")
    end
    it "responds 403 Forbidden" do
      post "/api/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when the user is an admin" do
    it "responds 201 Created with the new region"
    it "responds 422 Unprocessable Content when the name is blank"
    it "responds 400 Bad Request when the region params are missing"
  end
end