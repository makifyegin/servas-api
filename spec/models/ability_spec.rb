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
  end
end
