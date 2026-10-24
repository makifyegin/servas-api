# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Showing a member", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }

  before { stub_authenticated_user }

  it "responds 401 Unauthorized when no token is given" do
    get "/api/me"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 200 OK when the user is signed in" do
    create(:member, hydra_sub: "akif")
    get "/api/me", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["hydra_sub"]).to eq("akif")
  end

  it "responds 404 Not Found when the member does not exist" do
    get "/api/me", headers: headers
    expect(response).to have_http_status(:not_found)
  end
end
