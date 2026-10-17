require "rails_helper"

RSpec.describe "POST /api/countries", type: :request do
  let(:params) { { country: { name: "Ireland" } } }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }

  it "responds 401 Unauthorized when no token is given" do
    post "/api/countries", params: params
    expect(response).to have_http_status(:unauthorized)
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member1")
    end
    it "responds 403 Forbidden" do
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when the user is an admin" do
    let(:group) { create(:group) }
    let(:params) { { country: { name: "Ireland", group_id: group.id } } }
    before do
      stub_authenticated_user(sub: "admin1")
      create(:role, :si_admin, user_id: "admin1")
      create(:country, name: "United Kingdom", group_id: group.id)
    end
    it "responds 201 Created with the new country" do
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["name"]).to eq(params[:country][:name])
    end

    it "responds 422 Unprocessable Content when the name is blank" do
      post "/api/countries", params: { country: { name: "", group_id: group.id } }, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "responds 422 Unprocessable Content when the name is already taken" do
      post "/api/countries", params: { country: { name: "United Kingdom", group_id: group.id } }, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the country params are missing" do
      post "/api/countries", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
  context "when the user is a national secretary" do
    before do
      stub_authenticated_user(sub: "secretary1")
      create(:role, user_id: "secretary1", role: "national_secretary")
    end
    it "responds 403 Forbidden" do
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
