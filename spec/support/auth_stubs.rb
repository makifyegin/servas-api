# frozen_string_literal: true

module AuthStubs
  def stub_authenticated_user(sub: "akif")
    allow(HydraAdminApiClient).to receive(:introspect).and_return({ "active" => true, "sub" => sub })
  end

  def stub_login_deletion
    allow(HydraAdminApiClient).to receive(:revoke_sessions).and_return(true)
    allow(KratosAdminApiClient).to receive(:delete_identity).and_return(true)
  end
end
