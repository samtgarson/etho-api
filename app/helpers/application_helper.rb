module ApplicationHelper
  def current_user
    @current_user || nil
  end

  def instagram_auth_uri
    Insta.auth_url_for("#{client_root_url}process")
  end
end
