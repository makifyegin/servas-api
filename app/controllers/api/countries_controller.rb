module Api
  class CountriesController < Api::ApiController
    before_action :authorize_admin!, only: %i[create]
    before_action :set_country, only: %i[show update destroy]
    before_action :authorize_secretary!, only: %i[update destroy]
  def index
    @countries = Country.all
    render json: @countries
  end

  def show
    render json: @country
  end

    def create
      result = Country::Create.call(country_params: country_params)
      if result.success?
        render json: result[:country], status: :created        # take the country out of the box
      else
        render json: { error: result[:error] }, status: :unprocessable_content
      end
    end

    def update
      result = Country::Update.call(country: @country, country_params:)

      if result.success?
        render json: result[:country]
      else
        render json: { error: result[:error] }, status: :unprocessable_content
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
    def authorize_secretary!
      return if national_secretary_of?(@country.group)

      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
