# frozen_string_literal: true

class Member
  class Delete
    class << self
      # Deletes the member here, then their login in Hydra and Kratos.
      # All inside one transaction: if Hydra or Kratos fails, the local
      # delete is rolled back and the person can try again.
      def call(member_id:)
        response = OperationResponse.new
        delete_member(member_id)
        response
      rescue ActiveRecord::RecordNotDestroyed => e
        response[:error] = "Error deleting member: #{e}"
        response
      end

      private

      def delete_member(member_id)
        member = Member.find(member_id)
        Member.transaction do
          member.destroy!
          HydraAdminApiClient.revoke_sessions(subject: member.hydra_sub)
          KratosAdminApiClient.delete_identity(id: member.hydra_sub)
        end
      end
    end
  end
end
