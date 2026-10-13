require "rails_helper"

RSpec.describe "GET /api/countries", type: :request do
  context "when the user is signed in" do
    let(:headers) { { "Authorization" => "Bearer fake-token" } }
    before do
      stub_authenticated_user
      create(:country, name: "Ireland")
    end
    it "responds 200 OK with all countries" do
      get "/api/countries", headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(1)
    end
  end

  it "responds 401 Unauthorized when no token is given" do
    get "/api/countries"
    expect(response).to have_http_status(:unauthorized)
  end
end
