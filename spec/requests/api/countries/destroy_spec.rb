require "rails_helper"

RSpec.describe "DELETE /api/countries/:id", type: :request do
  let(:group) { create(:group) }
  let(:country) { create(:country, group_id: group.id) }
  let(:region) { create(:region, country: country) }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  it "responds 401 Unauthorized when no token is given" do
    delete "/api/countries/#{country.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is an admin" do
    before do
      stub_authenticated_user(sub: "admin1")
      create(:role, user_id: "admin1", role: "admin")
    end
    it "responds 204 admin can delete country" do
      delete "/api/countries/#{country.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
    it "responds 404 Not Found when the country does not exist" do
      delete "/api/countries/0", headers: headers
      expect(response).to have_http_status(:not_found)
    end
    it "responds 422 Unprocessable Content when the country has regions" do
      region
      delete "/api/countries/#{country.id}", headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  context "when the user is a member" do
  end
end
