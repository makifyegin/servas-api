require "rails_helper"

RSpec.describe Country, type: :model do
  it "has a valid factory" do
    expect(build(:country)).to be_valid
  end

  it "is not valid without a group" do
    country = build(:country, group: nil)
    expect(country).not_to be_valid
  end
end
