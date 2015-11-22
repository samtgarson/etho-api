class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /users/1
  def show
    render json: @user
  end

  private

  def set_user
    if params[:id] == 'self' || [:id] == 'me'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end
end
