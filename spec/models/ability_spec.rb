require 'rails_helper'
require 'cancan/matchers'
RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user_id) }
  let(:user_id) { "national_secretary" }


  describe "Country" do
    let(:country) { create(:country) }

    context "with a national secretary of the country's group" do
      before do
        # create a role for user_id: national secretary of country's group
        create(:role, user_id:, role: "national_secretary", group: country.group)
      end
      it { is_expected.to be_able_to(:update, country) }
    end


    context "with a national secretary of another group" do
      let(:group) { create(:group) }
      before { create(:role, user_id: "national_secretary", group: group) }

      it { is_expected.not_to be_able_to(:update, country) }
    end

    context "with a user who has no role" do

      it { is_expected.not_to be_able_to(:update, country) }
      it { is_expected.not_to be_able_to(:create, Country) }
    end
    context "with the SI admin" do
      before { create(:role, :si_admin, user_id:) }

      it { is_expected.to be_able_to(:create, Country) }
    end

  end
  describe "Region" do
    let(:country) { create(:country) }
    let(:region) { create(:region, country: country) }

    context "with a national secretary of the country's group" do
      before { create(:role, user_id: "national_secretary", group: country.group) }
      it {is_expected.to be_able_to(:create, region) }
    end
    context "with a national secretary of another group" do
      let(:group) { create(:group) }
      before { create(:role, user_id: "national_secretary", group: group) }
      it { is_expected.not_to be_able_to(:create, region) }
    end
  end

  describe "Role" do
    let(:country) { create(:country) }
    let(:region) { create(:region, country:) }
    context "with a national secretary of the country's group" do
      before { create(:role, user_id: "national_secretary", group: country.group) }

      it { is_expected.to be_able_to(:create, Role.new(role: "interviewer", region:))}
      it { is_expected.not_to be_able_to(:create, Role.new(role: "si_admin", region:)) }

    end

    context "with a national secretary of another group" do
      before { create(:role, user_id:, group: create(:group, name: "Servas Germany")) }

      it { is_expected.not_to be_able_to(:create, Role.new(role: "interviewer", region: )) }
    end
  end
end
