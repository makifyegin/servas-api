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
    end
    it "responds 403 Forbidden" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when the user is the national secretary of the country's group" do
    before do
      stub_authenticated_user(sub: "secretary1")
      create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
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

  context "when the user is the national secretary of another group" do
    before do
      stub_authenticated_user(sub: "secretary2")
      create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
    end
    it "responds 403 Forbidden" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
      expect(Region.find_by(name: "West Midlands")).to be_nil
    end
  end
end
