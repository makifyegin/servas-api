require 'rails_helper'

RSpec.describe "PATCH /api/countries/:id", type: :request do
  let(:created_country) { create(:country) }
  let(:params) do
    { country: { name: 'New Country Name' } }
  end
  let(:other_country) { create(:country) }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }

  context "when the user is a national secretary" do
    before do
      stub_authenticated_user(sub: "secretary1")
      create(:role, user_id: "secretary1", role: "national_secretary", group: created_country.group)
    end

    it "responds 200 OK with the updated country" do
      put("/api/countries/#{created_country.id}", headers:, params:)
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["name"]).to eq("New Country Name")
    end

    it "responds 404 Not Found when the country does not exist" do
      put("/api/countries/0", headers:, params:)
      expect(response).to have_http_status(:not_found)
    end

    it "responds 422 Unprocessable Content when the name is blank" do
      put("/api/countries/#{created_country.id}", headers:, params: { country: { name: "" } })
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "responds 422 Unprocessable Content when the name already taken" do
      put("/api/countries/#{created_country.id}", headers:, params: { country: { name: other_country.name } })
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "responds 400 Bad Request when the country params are missing" do
      put("/api/countries/#{created_country.id}", headers:)
      expect(response).to have_http_status(:bad_request)
    end


    it "does not move the country to another group" do
      original_group = created_country.group
      other_group = create(:group, name: "Servas Germany")
      put("/api/countries/#{created_country.id}", headers:, params: { country: { group_id: other_group.id } })
      expect(created_country.reload.group).to eq(original_group)
    end
  end

  context "when the user is a member" do
    before do
      stub_authenticated_user(sub: "member_user")
    end
    it 'responds 403 when the user is a member' do
      put("/api/countries/#{created_country.id}", headers:, params:)
      expect(response).to have_http_status(:forbidden)
    end
  end
  context "when the user is not a member" do
    it 'responds 401 when the user no token given' do
      put("/api/countries/#{created_country.id}",  params:)
      expect(response).to have_http_status(:unauthorized)
    end
  end
  context "when the user is the national secretary of another group" do
    before do
      stub_authenticated_user(sub: "secretary2")
      create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
    end
    it "responds 403 Forbidden" do
      put("/api/countries/#{created_country.id}", headers:, params:)
      expect(response).to have_http_status(:forbidden)
      expect(created_country.reload.name).not_to eq("New Country Name")
    end
  end
end
