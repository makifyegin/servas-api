require "rails_helper"

RSpec.describe "PUT /api/countries/:country_id/regions/:id", type: :request do
  let(:country) { create(:country) }
  let(:region) { create(:region, country:) }
  let(:params) { { region: { name: "Yorkshire" } } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  it "responds 401 Unauthorized when no token is given" do
    put "/api/countries/#{country.id}/regions/#{region.id}", params: params
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member1")
      create(:role, user_id: "member1", role: "member")
    end
    it "responds 403 Forbidden" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when the user is an admin" do
    before do
      stub_authenticated_user(sub: "admin")
      create(:role, user_id: "admin", role: "admin")
    end
    it "responds 200 OK with the new region" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: params
      expect(response).to have_http_status(:ok)
      expect(Region.find_by(name: "Yorkshire")).to_not be_nil
    end
    it "responds 422 Unprocessable Content when the name is blank" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: { region: { name: "", country_id: region.country.id } }
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the region params are missing" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
    it "responds 404 NOT FOUND when the region not exist" do
      put "/api/countries/#{country.id}/regions/0", headers: headers, params: params
      expect(response).to have_http_status(:not_found)
    end
  end
end
