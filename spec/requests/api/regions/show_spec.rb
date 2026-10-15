require "rails_helper"

RSpec.describe "Showing a country", type: :request do
  it "Responds 401 Unauthorized when no token is given" do
    get "/api/countries/1"
    expect(response).to have_http_status(:unauthorized)
  end
  context "when the user signed in" do
    let(:headers) { { "Authorization" => "Bearer fake-token" } }
    before do
      stub_authenticated_user
    end
    it "responds 404 Not Found when the country does not exist" do
      get "/api/countries/99", headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it "responds 200 OK when the country exists" do
      country = create(:country, name: "Ireland")
      get "/api/countries/#{country.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq(country.name)
    end
  end
end
