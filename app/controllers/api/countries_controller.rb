module Api
  class CountriesController < Api::ApiController
    before_action :authorize_admin!, only: [ :create, :update, :destroy ]
    before_action :set_country, only: [ :destroy ]
  def index
    @countries = Country.all
    render json: @countries
  end

  def show
    country = Country.find(params[:id])
    render json: country
  end

    def create
      country = Country.new(country_params)
      if country.save
        render json: country, status: :created
      else
        render json: { error: "Unable to create country" }, status: :unprocessable_entity
      end
    end

    def update
      country = Country.find(params[:id])
      if country.update(country_params)
        render json: country
      else
        render json: country.errors, status: :unprocessable_entity
      end
    end

    def destroy
      result = Country::Delete.call(country_id: params[:id])

      if result.success?
        head :no_content
      else
        render json: { error: result[:error] }, status: :unprocessable_content
      end
    end

    private

    def country_params
      params.require(:country).permit(:name, :group_id)
    end

    def set_country
      @country = Country.find(params[:id])
    end
  end
end
