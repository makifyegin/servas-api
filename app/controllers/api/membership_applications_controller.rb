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

    private

    def set_member
      @member = Member.find_by!(hydra_sub: @current_user)
    end
  end
end
