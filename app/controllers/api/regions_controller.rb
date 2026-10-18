# frozen_string_literal: true

module Api
class RegionsController < Api::ApiController
  before_action :set_country
  before_action :set_region, only: %i[show update destroy]
  def index
    @regions = @country.regions
    render json: @regions
  end

  def show
    render json: @region
  end


  def create
    authorize! :create, Region.new(country: @country)
    result = Region::Create.call(country: @country, region_params: region_params)
    if result.success?
      render json: result[:region], status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_content

    end
  end

  def update
    authorize! :update, @region
    result = Region::Update.call(region: @region, region_params:)
    if result.success?
      render json: result[:region]
    else
      render json: { error: result[:error] }, status: :unprocessable_content
    end
  end

  def destroy
    authorize! :destroy, @region
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
