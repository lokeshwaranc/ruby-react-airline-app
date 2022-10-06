class Api::V1::AirlinesController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    airlines = Airline.all

    render json: render_json(airlines, options)
  end

  def show
    airline = Airline.find_by(slug: params[:slug])

    render json: render_json(airline, options)
  end

  def create
    airline = Airline.new(airline_params)

    if airline.save
      render json: AirlineSerializer.new(airline).serialized_json
    else
      render json: {error: airline.errors.messages}, status: 422
    end
  end

  def update
    airline = Airline.find_by(slug: params[:slug])

    if airline.update(airline_params)
      render json: render_json(airline, options)
    else
      render json: render_error(airline)
    end
  end

  def destroy
    airline = Airline.find_by(slug: params[:slug])

    if airline.destroy
      head :no_content
    else
      render json: render_error(airline)
    end 
  end

  private

  def airline_params
    params.require(:airline).permit(:name, :image_url)
  end

  def render_json(records, options={})
    serialized_data = AirlineSerializer.new(records, options).serialized_json

    return serialized_data
  end

  def render_error(record)
    return {error: record.errors.messages}, status: 422
  end

  def options
    @options ||= { include: %i[reviews] }
  end

end
