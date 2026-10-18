
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Creating a region ", type: :request do
  let(:country) { create(:country) }
  let(:params) { { region: { name: "West Midlands" } } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  before do
    stub_authenticated_user(sub: "secretary1")
    create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
  end
  it "responds 401 Unauthorized when no token is given" do
    post "/api/countries/#{country.id}/regions", params: params
    expect(response).to have_http_status(:unauthorized)
  end

    it "responds 403 Forbidden when the user is a member" do
      stub_authenticated_user(sub: "member1")
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
    end

  it "responds 201 Created when the user is the national secretary of the country's group" do
    post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:created)
      expect(Region.find_by(name: "West Midlands")).to_not be_nil
    end
    it "responds 422 Unprocessable Content when the name is blank" do
      post "/api/countries/#{country.id}/regions", headers: headers, params: { region: { name: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the region params are missing" do
      post "/api/countries/#{country.id}/regions", headers: headers
      expect(response).to have_http_status(:bad_request)
    end



    it "responds 403 Forbidden when the user is the national secretary of another group" do
      stub_authenticated_user(sub: "secretary2")
      create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
      post "/api/countries/#{country.id}/regions", headers: headers, params: params
      expect(response).to have_http_status(:forbidden)
      expect(Region.find_by(name: "West Midlands")).to be_nil
    end
end
