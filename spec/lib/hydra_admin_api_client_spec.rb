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

  describe ".introspect" do
    let(:conn) do
      Faraday.new do |f|
        f.request :url_encoded
        f.response :json
        f.response :raise_error
        f.adapter :test, stubs
      end
    end

    it "returns the active flag and subject of a valid token" do
      stubs.post("admin/oauth2/introspect", "token=good-token") do
        [ 200, { "Content-Type" => "application/json" }, { active: true, sub: "abc-123" }.to_json ]
      end

      expect(described_class.introspect(token: "good-token")).to include("active" => true, "sub" => "abc-123")
      stubs.verify_stubbed_calls
    end

    it "returns active false for an expired or unknown token" do
      stubs.post("admin/oauth2/introspect", "token=bad-token") do
        [ 200, { "Content-Type" => "application/json" }, { active: false }.to_json ]
      end

      expect(described_class.introspect(token: "bad-token")).to eq("active" => false)
    end

    it "raises when Hydra fails" do
      stubs.post("admin/oauth2/introspect") { [ 500, {}, "" ] }

      expect { described_class.introspect(token: "any") }.to raise_error(Faraday::ServerError)
    end
  end

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
