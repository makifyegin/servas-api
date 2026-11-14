# frozen_string_literal: true

require "rails_helper"

RSpec.describe KratosAdminApiClient do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) do
    Faraday.new do |f|
      f.response :raise_error
      f.adapter :test, stubs
    end
  end

  before { allow_any_instance_of(described_class).to receive(:conn).and_return(conn) }

  it "deletes the identity" do
    stubs.delete("admin/identities/abc-123") { [ 204, {}, "" ] }

    expect(described_class.delete_identity(id: "abc-123")).to be(true)
    stubs.verify_stubbed_calls
  end

  it "counts an identity that is already gone as deleted" do
    stubs.delete("admin/identities/abc-123") { [ 404, {}, "" ] }

    expect(described_class.delete_identity(id: "abc-123")).to be(true)
  end

  it "raises when Kratos fails" do
    stubs.delete("admin/identities/abc-123") { [ 500, {}, "" ] }

    expect { described_class.delete_identity(id: "abc-123") }.to raise_error(Faraday::ServerError)
  end
end
