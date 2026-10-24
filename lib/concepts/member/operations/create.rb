# frozen_string_literal: true

class Member
  class Create
    class << self
      def call(member_params:)
        response = OperationResponse.new
        response[:member] = create_member(member_params:)
        response[:member].save!
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error creating member: #{e}"
        response
      end

      private

      def create_member(member_params:)
        Member.find_or_initialize_by(member_params)
      end
    end
  end
end
