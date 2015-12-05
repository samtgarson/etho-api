class AccessDeniedError < StandardError
end
class NotAuthenticatedError < StandardError
end
class AuthenticationTimeoutError < StandardError
end

class ApplicationController < ActionController::Base
  attr_reader :current_user

  rescue_from AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from NotAuthenticatedError, with: :user_not_authenticated
  rescue_from AccessDeniedError, with: :forbidden_resource

  def authenticate_request!
    fail NotAuthenticatedError unless http_auth_token_present?
    @current_user = JsonWebToken.user_from(@http_auth_token)
  rescue JWT::ExpiredSignature
    raise AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise NotAuthenticatedError
  end

  def greeting
    render json: { etho: 'Hello, human.' }
  end

  def heartbeat
    render json: { heartbeat: true }
  end

  def application_error
    render json: { errors: ['Something went wrong.'] }, status: 500
  end

  def not_found
    render json: { errors: ['That resource cannot be found.'] }, status: 404
  end

  private

  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_token_present?
    @http_auth_token ||= if request.headers['Authorization'].present?
                           request.headers['Authorization'].split(' ').last
                         end
  end

  def authentication_timeout
    render json: { errors: ['Authentication timed out or invalid.'] }, status: 419
  end

  def forbidden_resource
    render json: { errors: ['Not authorized to access resource.'] }, status: :forbidden
  end

  def user_not_authenticated
    render json: { errors: ['Not authenticated.'] }, status: :unauthorized
  end
end
