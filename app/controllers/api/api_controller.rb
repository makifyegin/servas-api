module Api
  class ApiController < ApplicationController
    before_action :load_current_user
    before_action :authorize_user
    rescue_from CanCan::AccessDenied, with: :not_allowed
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request

    private

    def not_allowed(exception)
      render json: { error: "Forbidden" }, status: :forbidden
    end
    def not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def bad_request(exception)
      render json: { error: exception.message }, status: :bad_request
    end

    def load_current_user
      token = request.headers["Authorization"]
      return if token.nil?

      token = token.strip.delete_prefix("Bearer ")
      result = HydraAdminApiClient.introspect(token: token)
      return unless result["active"]

      @current_user = result["sub"]
      Rails.logger.info("Current User #{@current_user}")
    end

    def authorize_user
      return unless @current_user.nil?

      render json: { error: "Unauthorized" }, status: :unauthorized
    end


    def current_ability
      @current_ability ||= Ability.new(@current_user)
    end
  end
end
