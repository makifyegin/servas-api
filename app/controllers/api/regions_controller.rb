# frozen_string_literal: true

module Api
class RegionsController < Api::ApiController
  before_action :set_country
  before_action -> { authorize_secretary_of!(@country.group) }, only: %i[create update destroy]
  before_action :set_region, only: %i[show update destroy]
  def index
    @regions = @country.regions
    render json: @regions
  end

  def show
    render json: @region
  end


  def create
    result = Region::Create.call(country: @country, region_params: region_params)
    if result.success?
      render json: result[:region], status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_content

    end
  end

  def update
    result = Region::Update.call(region: @region, region_params:)
    if result.success?
      render json: result[:region]
    else
      render json: { error: result[:error] }, status: :unprocessable_content
    end
  end

  def destroy
    result = Region::Delete.call(country: @country, region_id: params[:id])
    if result.success?
      head :no_content
    else
      render json: { error: result[:error] }, status: :unprocessable_content
    end
  end

  private

  def set_country
    @country = Country.find(params[:country_id])
  end
  def region_params
    params.require(:region).permit(:name)
  end
  def set_region
    @region = @country.regions.find(params[:id])
  end
end
end
