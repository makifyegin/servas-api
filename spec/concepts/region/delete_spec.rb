require "rails_helper"

RSpec.describe Country::Delete do
  let(:country) { create(:country) }
  let(:region) { create(:region, country: country) }
  it "deletes the country" do
    response = Country::Delete.call(country_id: country.id)
    expect(Country.find_by(id: country.id)).to be_nil
    expect(response).to be_success
  end
  it "returns an error when the country has regions" do
    region
    response = Country::Delete.call(country_id: country.id)
    expect(Country.find_by(id: country.id)).to_not be_nil
    expect(response).to_not be_success
  end
end
