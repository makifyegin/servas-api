# frozen_string_literal: true

class MembershipApplication
  class Cancel
    class << self
      def call(membership_application:)
        response = OperationResponse.new
        membership_application.update!(status: "cancelled")
        response[:membership_application] = membership_application
        response
      rescue ActiveRecord::RecordInvalid => e
        response[:error] = "Error canceling membership application: #{e}"
        response
      end
    end
  end
end
