class ObservationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  def index
    @observations = Observation.all
  end

  def new
    @observation = Observation.new
    @markers = Observation.all.geocoded.map do |observation|
      
      {
        lat: observation.latitude,
        lng: observation.longitude,
        info_window_html: render_to_string(partial: "shared/observation_window", locals: {observation: observation})
      }
    end
  end

  def create
    @observation = Observation.new(observations_params)
    category = Category.find(params[:observation][:category_id])
    @observation.category = category
    @observation.user = current_user
    if @observation.save
      redirect_to root_path, success: "L'observation a bien été créée"
    else
      render :new, status: :unprocessable_entity
      raise
    end
  end

  private

  def observations_params
    params.require(:observation).permit(:title, :location, :description, :dangerosity, :latitude, :longitude, :category_id)
  end
end
