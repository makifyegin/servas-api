module Api
  class MembersController < Api::ApiController
    def create
      authorize! :create, Member
      result = Member::Create.call(member_params: { hydra_sub: @current_user })
      if result.success?
        render json: result[:member], status: result[:member].previously_new_record? ? :created : :ok
      else
        render json: { error: result[:error] }, status: :unprocessable_content
      end
    end
  end
end
