require 'rails_helper'

RSpec.describe AuthController, type: :request do
  describe 'GET /auth' do
    stub_out_instagram_api

    before do
      FactoryGirl.create(:user, id: example_user[:id])
    end

    context 'given a valid code' do
      it 'returns token for existing user' do
        post '/auth', code: 'valid_code', redirect: '123'

        expect(response).to be_success
        expect(json).to have_key('token')
        expect(json['user']).to include('_id' => example_user[:id].to_i)
      end
    end

    context 'given an invalid code' do
      it 'returns an error' do
        post '/auth', code: 'invalid_code', redirect: '123'

        expect(response).not_to be_success
        expect(json['errors']).to include('Not authenticated.')
      end
    end
  end
end
