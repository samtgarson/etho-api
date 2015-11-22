class AuthController < ApplicationController
  def create
    user = User.verify_auth_code(params[:code])
    render json: {
      'token' => user.new_auth_token,
      'user' => user.basics
    }, status: :created

  rescue Instagram::BadRequest
    raise NotAuthenticatedError
  end
end
