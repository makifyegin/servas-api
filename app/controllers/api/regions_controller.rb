# frozen_string_literal: true
module Api
class RegionsController < Api::ApiController
  before_action :authorize_admin!, only: [ :create ]
  before_action :set_region, only: [  :show ]
  def index
    @regions = Region.all
    render json: @regions
  end

  def show
    render json: @region
  end


  def create
    result = Region::Create.call(region_params: set_params)
    if result.success?
      render json: result[:region], status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_content

    end
  end

  private
  def set_params
    params.require(:region).permit(:name, :country_id)
  end
  def set_region
    @region = Region.find(params[:id])
  end

end
end