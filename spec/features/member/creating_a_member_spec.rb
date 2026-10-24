require "rails_helper"

RSpec.describe "Creating a member", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  before { stub_authenticated_user(sub: "new_user") }
  it "responds 401 Unauthorized when no token is given" do
    post "/api/members"
    expect(response).to have_http_status(:unauthorized)
  end
    it "responds 201 Created with an amiko member when the user is signed in" do
      post "/api/members",  headers: headers
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["status"]).to eq("amiko")
    end
end
