require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET /user' do
    mock_authorization

    it 'returns the current user' do
      get user_path 'self'
      expect(response).to have_http_status(200)
      expect(json['_id']).to eq(current_user.id)
    end

    it 'returns the current user by id' do
      get user_path current_user._id
      expect(response).to have_http_status(200)
      expect(json['_id']).to eq(current_user.id)
    end
  end
end
