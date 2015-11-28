class Insta
  class << self
    attr_accessor :access_token

    def instagram_id_for(code)
      response = Instagram.get_access_token(code, redirect_uri: ENV['instagram_redirect'], scope: 'relationships')
      @access_token = response['access_token']
      response['user']['id'].to_i
    end
  end

  def initialize
    @client = Instagram.client(access_token: self.class.access_token)
  end

  def profile(user = 'self')
    attributes = @client.user(user)
    UserBuilder.new(attributes.dup).user
  end

  def user_images(user = 'self', options = {})
    list = @client.user_recent_media(user, options)
    opts = options.merge(max_id: list.pagination.next_max_id)

    images = list.map { |i| ImageBuilder.new(i).image }
    images += user_images(user, opts) if list.pagination.next_max_id.present?
    images
  end

  def image(item_id)
    attributes = @client.media_item(item_id)
    ImageBuilder.new(attributes).image
  end
end
