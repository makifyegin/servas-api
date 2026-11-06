module Api
  class MembershipApplicationsController < ApiController
    before_action :set_member

    def create
      authorize! :create, @member.membership_applications.build
      result = MembershipApplication::Create.call(
        member: @member,
        region_id: params.require(:region_id)
      )

      if result.success?
        render json: result[:membership_application], status: :created
      else
        render json: { error: result[:error] }, status: :unprocessable_content
      end
    end

    def cancel
      application = @member.membership_applications.find_by!(status: MembershipApplication::OPEN_STATUSES)
      authorize! :cancel, application
      result = MembershipApplication::Cancel.call(membership_application: application)

      if result.success?
        render json: result[:membership_application], status: :ok
      else
        render json: { error: result[:error] }, status: :unprocessable_content
      end
    end



    private

    def set_member
      @member = Member.find_by!(hydra_sub: @current_user)
    end
  end
end
