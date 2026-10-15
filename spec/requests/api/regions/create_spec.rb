require "rails_helper"

RSpec.describe "POST /api/countries/:country_id/regions", type: :request do
  let(:country) { create(:country) }
  let(:params) { { region: { name: "West Midlands" } } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  it "responds 401 Unauthorized when no token is given" do
    post "/api/countries/#{country.id}/regions", params: params
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member1")
      create(:role, user_id: "member1", role: "member")
    end
    it "responds 403 Forbidden" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when the user is an admin" do
    before do
      stub_authenticated_user(sub: "admin")
      create(:role, user_id: "admin", role: "admin")
    end
    it "responds 201 Created with the new region" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:created)
      expect(Region.find_by(name: "West Midlands")).to_not be_nil
    end
    it "responds 422 Unprocessable Content when the name is blank" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: { region: { name: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the region params are missing" do
      post "/api/countries/#{country.id}/regions", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
