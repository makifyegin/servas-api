require "rails_helper"

RSpec.describe "Listing regions", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:country) { create(:country) }
  let(:region) { create(:region, country: country) }
  before { stub_authenticated_user }

  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries/#{country.id}/regions"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK with only this country's regions when the user is signed in" do
    region
    create(:region)
    get "/api/countries/#{country.id}/regions", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.size).to eq(1)
  end
end
