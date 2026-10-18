# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Updating a country", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:country) { create(:country, name: "United Kingdom") }
  let(:params) { { country: { name: "New Country Name" } } }

  before do
    stub_authenticated_user(sub: "secretary1")
    create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
  end

  it "responds 401 Unauthorized when no token is given" do
    put("/api/countries/#{country.id}", params:)
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 403 Forbidden when the user is an ordinary member" do
    stub_authenticated_user(sub: "member1")
    put("/api/countries/#{country.id}", headers:, params:)
    expect(response).to have_http_status(:forbidden)
  end

  it "responds 403 Forbidden when the user is the national secretary of another group" do
    stub_authenticated_user(sub: "secretary2")
    create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
    put("/api/countries/#{country.id}", headers:, params:)
    expect(response).to have_http_status(:forbidden)
    expect(country.reload.name).to eq("United Kingdom")
  end

  it "keeps the country in its group when a group_id is sent", openapi: false do
    other_group = create(:group, name: "Servas Germany")
    put("/api/countries/#{country.id}", headers:, params: { country: { group_id: other_group.id } })
    expect(response).to have_http_status(:ok)
    expect(country.reload.group).not_to eq(other_group)
  end

  it "responds 200 OK with the updated country when the user is the national secretary of the country's group" do
    put("/api/countries/#{country.id}", headers:, params:)
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["name"]).to eq("New Country Name")
  end

  it "responds 422 Unprocessable Content when the name is blank" do
    put("/api/countries/#{country.id}", headers:, params: { country: { name: "" } })
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "responds 422 Unprocessable Content when the name is already taken" do
    create(:country, name: "France", group: country.group)
    put("/api/countries/#{country.id}", headers:, params: { country: { name: "France" } })
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "responds 400 Bad Request when the country params are missing" do
    put("/api/countries/#{country.id}", headers:)
    expect(response).to have_http_status(:bad_request)
  end

  it "responds 404 Not Found when the country does not exist" do
    put("/api/countries/0", headers:, params:)
    expect(response).to have_http_status(:not_found)
  end
end