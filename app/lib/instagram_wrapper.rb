class InstagramWrapper
  def self.profile(user)
    Instagram.client.user(user).tap do |u|
      u._id = u.delete('id').to_i
    end
  end

  def self.id_for(code)
    response = Instagram.get_access_token(code, redirect_uri: ENV['instagram_redirect'], scope: 'relationships')
    @access_token = response.access_token
    response.user.id.to_i
  end
end
