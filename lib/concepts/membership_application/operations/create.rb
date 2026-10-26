# frozen_string_literal: true

class MembershipApplication
  class Create
    class << self
      def call(member:, region_id:)
        response = OperationResponse.new
        response[:membership_application] = build_membership_application(member:, region_id:)
        response[:membership_application].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error creating membership application: #{e}"
        response
      end

      private
      def build_membership_application(member:, region_id:)
        member.membership_applications.build(region_id:)
      end
    end
  end
end
