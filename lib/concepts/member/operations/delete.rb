# frozen_string_literal: true

class Member
  class Delete
    class << self
      def call(member_id:)
        response = OperationResponse.new
        delete_member(member_id)
        response
      rescue StandardError => e
        Sentry.capture_exception(e)
        response[:error] = "Error deleting member: #{e}"
        response
      end

      private

      def delete_member(member_id)
        member = Member.find(member_id)
        member.destroy!
      end
    end
  end
end
