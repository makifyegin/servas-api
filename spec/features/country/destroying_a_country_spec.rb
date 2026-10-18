# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deleting a country", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:country) { create(:country, name: "United Kingdom") }

  before do
    stub_authenticated_user(sub: "secretary1")
    create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
  end

  it "responds 401 Unauthorized when no token is given" do
    delete "/api/countries/#{country.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 403 Forbidden when the user is an ordinary member" do
    stub_authenticated_user(sub: "member1")
    delete "/api/countries/#{country.id}", headers: headers
    expect(response).to have_http_status(:forbidden)
    expect(Country.exists?(country.id)).to be(true)
  end

  it "responds 403 Forbidden when the user is the national secretary of another group" do
    stub_authenticated_user(sub: "secretary2")
    create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
    delete "/api/countries/#{country.id}", headers: headers
    expect(response).to have_http_status(:forbidden)
    expect(Country.exists?(country.id)).to be(true)
  end

  it "responds 204 No Content when the user is the national secretary of the country's group" do
    delete "/api/countries/#{country.id}", headers: headers
    expect(response).to have_http_status(:no_content)
    expect(Country.exists?(country.id)).to be(false)
  end

  it "responds 422 Unprocessable Content when the country has regions" do
    create(:region, country:, name: "London")
    delete "/api/countries/#{country.id}", headers: headers
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "responds 404 Not Found when the country does not exist" do
    delete "/api/countries/0", headers: headers
    expect(response).to have_http_status(:not_found)
  end
end