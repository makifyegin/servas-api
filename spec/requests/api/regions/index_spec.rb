require "rails_helper"

RSpec.describe "GET /api/countries/:country_id/regions", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:country) { create(:country) }
  let(:region) { create(:region, country: country) }
  context "when the user is signed in" do
    before do
      stub_authenticated_user
    end
    it "responds 200 OK with all regions" do
      region
      create(:region)
      get "/api/countries/#{country.id}/regions", headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(1)
    end
    end

    context "when the user is not signed in" do
  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries/#{country.id}/regions"
    expect(response).to have_http_status(:unauthorized)
  end
  end
end
