# frozen_string_literal: true

require "rails_helper"

RSpec.describe HydraAdminApiClient do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) do
    Faraday.new do |f|
      f.response :raise_error
      f.adapter :test, stubs
    end
  end

  before { allow_any_instance_of(described_class).to receive(:conn).and_return(conn) }

  describe ".revoke_sessions" do
    it "revokes all consent and login sessions of the subject" do
      stubs.delete("admin/oauth2/auth/sessions/consent?subject=abc-123&all=true") { [ 204, {}, "" ] }
      stubs.delete("admin/oauth2/auth/sessions/login?subject=abc-123") { [ 204, {}, "" ] }

      expect(described_class.revoke_sessions(subject: "abc-123")).to be(true)
      stubs.verify_stubbed_calls
    end

    it "raises when Hydra fails" do
      stubs.delete("admin/oauth2/auth/sessions/consent?subject=abc-123&all=true") { [ 500, {}, "" ] }

      expect { described_class.revoke_sessions(subject: "abc-123") }.to raise_error(Faraday::ServerError)
    end
  end
end
