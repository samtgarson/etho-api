module InstagramHelpers
  def stub_out_instagram_api
    before(:each) do
      setup_get_access_token
      setup_invalid_access_token
      setup_user
      setup_image
    end

    assign_user
    assign_image
  end

  private

  def assign_user
    let(:example_user) do
      JSON.parse(instagram_user_response)['data'].deep_symbolize_keys
    end
  end

  def assign_image
    let(:example_image) do
      JSON.parse(instagram_image_response)['data'].deep_symbolize_keys
    end
  end

  def setup_get_access_token
    stub_request(:any, 'https://api.instagram.com/oauth/access_token/')
      .with(body: hash_including(code: 'valid_code'))
      .to_return(body: instagram_token_response.to_s, status: 200)
  end

  def setup_invalid_access_token
    stub_request(:any, 'https://api.instagram.com/oauth/access_token/')
      .with(body: hash_including(code: 'invalid_code'))
      .to_return(body: invalid_instagram_token_response.to_s, status: 400)
  end

  def setup_user
    stub_request(:any, %r{https://api.instagram.com/v1/users/})
      .to_return(body: instagram_user_response.to_s, status: 200)
  end

  def setup_image
    stub_request(:any, %r{https://api.instagram.com/v1/media/})
      .to_return(body: instagram_image_response.to_s, status: 200)
  end

  def instagram_token_response
    File.read('spec/fixtures/auth_token.json')
  end

  def invalid_instagram_token_response
    File.read('spec/fixtures/invalid_auth_token.json')
  end

  def instagram_user_response
    File.read('spec/fixtures/user.json')
  end

  def instagram_image_response
    File.read('spec/fixtures/image.json')
  end
end
