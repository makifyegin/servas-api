require "rails_helper"

RSpec.describe "Deleting a region", type: :request do
  let(:country) { create(:country) }
  let(:region) { create(:region, country: country) }
  let(:headers) { { "Authorization" => "Bearer fake-token" } }
  let(:member) { create(:member, region:) }
  before do
    stub_authenticated_user(sub: "secretary1")
    create(:role, user_id: "secretary1", role: "national_secretary", group: country.group)
  end
  it "responds 401 Unauthorized when no token is given" do
    delete "/api/countries/#{country.id}/regions/#{region.id}"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 204 No Content when the user is the national secretary of the country's group" do      delete "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Region.find_by(id: region.id)).to be_nil
    end
    it "responds 404 Not Found when the region does not exist" do
      delete "/api/countries/#{country.id}/regions/0", headers: headers
      expect(response).to have_http_status(:not_found)
    end
    it "responds 422 Unprocessable Content when the region has members" do
      member
      delete "/api/countries/#{country.id}/regions/#{member.region.id}", headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "responds 404 Not Found when the region belongs to another country" do
      other_country = create(:country, name: "France", group: country.group)
      delete "/api/countries/#{other_country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:not_found)
      expect(Region.find_by(id: region.id)).to_not be_nil
    end



    it "responds 403 Forbidden when the user is an ordinary member" do
      stub_authenticated_user(sub: "member1")
      delete "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(Region.find_by(id: region.id)).to_not be_nil# still exists
    end


    it "responds 403 Forbidden when the user is the national secretary of another group" do
      stub_authenticated_user(sub: "secretary2")
      create(:role, user_id: "secretary2", role: "national_secretary", group: create(:group, name: "Servas Germany"))
      delete "/api/countries/#{country.id}/regions/#{region.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(Region.find_by(id: region.id)).to_not be_nil
  end
end
