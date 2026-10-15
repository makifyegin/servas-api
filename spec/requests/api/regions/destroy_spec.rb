require "rails_helper"

RSpec.describe "DELETE /api/countries/country_id/regions/:id", type: :request do
  let(:group) { create(:group) }
  let(:country) { create(:country, group_id: group.id) }
  let(:region) { create(:region, country: country) }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:member) { create(:member, region:) }

  it "responds 401 Unauthorized when no token is given" do
    delete "/api/countries/#{country.id}/regions/#{region.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is an admin" do
    before do
      stub_authenticated_user(sub: "admin1")
      create(:role, user_id: "admin1", role: "admin")
    end
    it "responds 204 No Content and deletes the region" do
      delete "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Region.find_by(id: region.id)).to be_nil
    end
    it "responds 404 Not Found when the region does not exist" do
      delete "/api/countries/#{country.id}/regions/0", headers: headers
      expect(response).to have_http_status(:not_found)
    end
    it "responds 422 Unprocessable Content when the region has members" do
      member
      delete "/api/countries/#{country.id}/regions/#{member.region.id}", headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member1")
      create(:role, user_id: "member1", role: "member")
    end

    it "responds 403 Forbidden" do
      delete "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(Region.find_by(id: region.id)).to_not be_nil# still exists
    end
  end
end
