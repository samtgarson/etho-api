class AuthController < ApplicationController
  def create
    user = User.verify_auth_code(code: params[:code], redirect: (params[:redirect] || request.referer))
    render json: {
      'token' => user.new_auth_token,
      'user' => user.basics
    }, status: :created

  rescue Instagram::BadRequest
    raise NotAuthenticatedError
  end
end
