# frozen_string_literal: true

class Member
  class Update
    class << self
      def call(member:, member_params:)
        response = OperationResponse.new
        response[:member] = member
        response[:member].assign_attributes(member_params)
        response[:member].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error updating member: #{e}"
        response
      end
    end
  end
end
