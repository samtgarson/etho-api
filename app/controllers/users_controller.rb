class UsersController < ApplicationController
  before_action :authenticate_request!
  before_action :set_user
  before_action :create_service, except: :show

  def show
    render json: @user
  end

  def stats
    if all_stats.values.exclude? nil
      render json: all_stats.to_json
      return
    end
    render json: no_images_error
  end

  def time
    season = @service.season
    time = @service.time_of_day
    if time && season
      render json: {
        season: season,
        time_of_day: time
      }
      return
    end
    render json: no_images_error
  end

  def colours
    colours = @service.colours
    favourite_colour = @service.favourite_colour
    if colours && favourite_colour
      render json: {
        colours: colours,
        favourite_colour: favourite_colour
      }
      return
    end
    render json: no_images_error
  end

  def tags
    if (tags = @service.tags)
      render json: { tags: tags }.to_json
      return
    end
    render json: no_images_error
  end

  private

  def all_stats
    {
      season: @service.season,
      time_of_day: @service.time_of_day,
      colours: @service.colours,
      favourite_colour: @service.favourite_colour,
      tags: @service.tags
    }
  end

  def no_images_error
    { 'errors': ['User has no images.'] }.to_json
  end

  def set_user
    if params[:id] == 'self' || [:id] == 'me'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  def create_service
    @service = UserStatisticsService.new(@user)
  end
end
