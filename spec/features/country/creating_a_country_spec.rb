require "rails_helper"

RSpec.describe "Creating a country", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:group) { create(:group) }
  let(:params) { { country: { name: "Ireland", group_id: group.id } } }
  before do
    stub_authenticated_user(sub: "admin1")
    create(:role, :si_admin, user_id: "admin1")
  end

  it 'responds 401 Unauthorized when no token is given' do
    post "/api/countries", params: params
    expect(response).to have_http_status(:unauthorized)
  end
    it "responds 403 Forbidden when the user is an ordinary member" do
      stub_authenticated_user(sub: "member1")
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it "responds 403 Forbidden when the user is a national secretary" do
      stub_authenticated_user(sub: "secretary1")
      create(:role, user_id: "secretary1", role: "national_secretary")
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it "responds 201 Created with the new country when the user is an SI admin" do
      post "/api/countries", params: params, headers: headers
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["name"]).to eq(params[:country][:name])
    end

    it "responds 422 Unprocessable Content when the name is blank" do
      post "/api/countries", params: { country: { name: "", group_id: group.id } }, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "responds 422 Unprocessable Content when the name is already taken" do
      create(:country, name: "United Kingdom", group_id: group.id)
      post "/api/countries", params: { country: { name: "United Kingdom", group_id: group.id } }, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
    it "responds 400 Bad Request when the country params are missing" do
      post "/api/countries", params: {}, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
end
