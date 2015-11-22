module RequestHelpers
  def json
    JSON.parse(response.body)
  end

  def mock_authorization
    let!(:current_user) { FactoryGirl.create(:user, id: '4079668', full_name: 'Sam Garson', username: 'samtgarson') }

    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticate_request!).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
    end
  end

  def authentication_headers
    'Bearer ' + JsonWebToken.encode('user_id' => current_user[:_id])
  end

  def expired_authentication_headers
    'Bearer ' + JsonWebToken.encode({ 'user_id' => current_user[:_id] }, 3.weeks.ago)
  end

  def invalid_authentication_headers
    'Bearer ' + 'invalid token'
  end
end
