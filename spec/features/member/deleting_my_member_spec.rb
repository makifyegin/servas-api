# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deleting my member data", type: :request do
  let(:headers) { { "Authorization" => "Bearer fake-token" } }

  before do
    stub_authenticated_user(sub: "akif")
    stub_login_deletion
  end

  it "responds 401 Unauthorized when no token is given" do
    delete "/api/me"
    expect(response).to have_http_status(:unauthorized)
  end

  it "responds 404 Not Found when the user has not joined yet" do
    delete("/api/me", headers:)
    expect(response).to have_http_status(:not_found)
  end

  it "responds 204 No Content and deletes the member" do
    member = create(:member, hydra_sub: "akif")
    delete("/api/me", headers:)

    expect(response).to have_http_status(:no_content)
    expect(Member.find_by(id: member.id)).to be_nil
  end

  it "revokes my Hydra sessions and deletes my Kratos identity" do
    create(:member, hydra_sub: "akif")
    delete("/api/me", headers:)

    expect(HydraAdminApiClient).to have_received(:revoke_sessions).with(subject: "akif")
    expect(KratosAdminApiClient).to have_received(:delete_identity).with(id: "akif")
  end

  it "deletes the member's membership applications too" do
    member = create(:member, hydra_sub: "akif")
    application = create(:membership_application, member:)
    delete("/api/me", headers:)

    expect(MembershipApplication.find_by(id: application.id)).to be_nil
  end

  it "does not delete another member" do
    other = create(:member)
    create(:member, hydra_sub: "akif")
    delete("/api/me", headers:)

    expect(Member.find_by(id: other.id)).to eq(other)
  end

  it "responds 422 Unprocessable Content when the member cannot be deleted" do
    create(:member, hydra_sub: "akif")
    allow(Member::Delete).to receive(:call).and_return(OperationResponse[error: "Error deleting member"])
    delete("/api/me", headers:)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["error"]).to eq("Error deleting member")
  end
end
