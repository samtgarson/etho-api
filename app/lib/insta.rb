class Insta
  class << self
    attr_accessor :access_token

    def auth_url_for(redirect)
      Instagram.authorize_url(redirect_uri: redirect)
    end

    def instagram_id_for(opts)
      response = Instagram.get_access_token(opts[:code], redirect_uri: opts[:redirect], scope: 'relationships')
      @access_token = response['access_token']
      response['user']['id'].to_s
    end

    def client
      @client ||= Instagram.client(access_token: access_token)
    end

    def profile(user = 'self')
      attributes = client.user(user)
      UserBuilder.new(attributes.dup).user
    end

    def user_images(user = 'self', options = {})
      list = client.user_recent_media(user, options)
      opts = options.merge(max_id: list.pagination.next_max_id)

      images = list.map { |i| ImageBuilder.new(i).image }
      images += user_images(user, opts) if list.pagination.next_max_id.present?
      images
    end

    def image(item_id)
      attributes = client.media_item(item_id)
      ImageBuilder.new(attributes.dup).image
    end
  end
end
