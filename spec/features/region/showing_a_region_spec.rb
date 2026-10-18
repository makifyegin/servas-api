# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Showing a region", type: :request do
  let(:country) { create(:country) }
  let(:region) { create(:region, country:, name: "London") }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  before do
    stub_authenticated_user
  end
  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries/#{country.id}/regions/#{region.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK when the user is signed in" do
    get "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["name"]).to eq(region.name)
  end
    it "responds 404 Not Found when the region does not exist" do
      get "/api/countries/#{country.id}/regions/0", headers: headers
      expect(response).to have_http_status(:not_found)
    end
    it "responds 404 Not Found when the region belongs to another country" do
      other_country = create(:country, name: "France")
      get "/api/countries/#{other_country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
end
