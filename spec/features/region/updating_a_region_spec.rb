require "rails_helper"

RSpec.describe "Updating a region", type: :request do
  let(:country) { create(:country) }
  let(:region) { create(:region, name: "West Midlands", country:) }
  let(:params) { { region: { name: "Yorkshire" } } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  before do
    stub_authenticated_user(sub: "secretary1")
    create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
  end
  it "responds 401 Unauthorized when no token is given" do
    put "/api/countries/#{country.id}/regions/#{region.id}", params: params
    expect(response).to have_http_status(:unauthorized)
  end

    it "responds 403 Forbidden when the user is an ordinary member" do
      stub_authenticated_user(sub: "member1")
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end
    it "responds 200 OK when the user is the national secretary of the country's group" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: params
      expect(response).to have_http_status(:ok)
      expect(Region.find_by(name: "Yorkshire")).to_not be_nil
    end
    it "responds 422 Unprocessable Content when the name is blank" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: { region: { name: "", country_id: region.country.id } }
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the region params are missing" do
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:bad_request)
    end
    it "responds 404 Not Found when the region does not exist" do
      put "/api/countries/#{country.id}/regions/0", headers: headers, params: params
      expect(response).to have_http_status(:not_found)
    end
    it "responds 404 Not Found when the region belongs to another country" do
      other_country = create(:country, name: "France", group: country.group)
      put "/api/countries/#{other_country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  it "responds 403 Forbidden when the user is the national secretary of another group" do      stub_authenticated_user(sub: "secretary2")
      create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
      put "/api/countries/#{country.id}/regions/#{region.id}", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
      expect(region.reload.name).to eq("West Midlands")
    end
end
