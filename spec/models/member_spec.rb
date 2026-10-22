require 'rails_helper'

RSpec.describe Member, type: :model do
  it "has valid factory" do
    member = build(:member)
    expect(member).to be_valid
  end
  # it "is not valid without name" do
  #   member = build(:member, name: nil)
  #   expect(member).not_to be_valid
  # end
  it "is valid without a region when the status is amiko" do
    member = build(:member, status: "amiko", region: nil)
    expect(member).to be_valid
  end

  it "is not valid without a region when the status is applied" do
    member = build(:member, status: "applied", region: nil)
    expect(member).not_to be_valid
  end
  it "is not valid without hydra_sub" do
    member = build(:member, hydra_sub: nil)
    expect(member).not_to be_valid
  end

  it "is not valid with not unique hydra_sub" do
    existing_member = create(:member)
    new_member = build(:member, hydra_sub: existing_member.hydra_sub)
    expect(new_member).not_to be_valid
  end
end
