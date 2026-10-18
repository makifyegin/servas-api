# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Showing a country", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:country) { create(:country, name: "Ireland") }

  before { stub_authenticated_user }

  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries/#{country.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK when the user is signed in" do
    get "/api/countries/#{country.id}", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["name"]).to eq("Ireland")
  end

  it "responds 404 Not Found when the country does not exist" do
    get "/api/countries/0", headers: headers
    expect(response).to have_http_status(:not_found)
  end
end