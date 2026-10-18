# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Listing countries", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:group) { create(:group) }

  before do
    stub_authenticated_user
    create(:country, name: "Ireland", group:)
    create(:country, name: "United Kingdom", group:)
  end

  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK with all countries when the user is signed in" do
    get "/api/countries", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.pluck("name")).to contain_exactly("Ireland", "United Kingdom")
  end
end