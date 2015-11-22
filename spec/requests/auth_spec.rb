require 'rails_helper'

RSpec.describe AuthController, type: :request do
  stub_out_instagram_api

  describe 'GET /auth' do
    before do
      FactoryGirl.create(:user, id: example_user[:id])
    end

    context 'given a valid code' do
      it 'returns token for existing user' do
        get '/auth/valid_code'

        expect(response).to be_success
        expect(json).to have_key('token')
        expect(json['user']).to include('id' => example_user[:id].to_i)
      end
    end

    context 'given an invalid code' do
      it 'returns an error' do
        get '/auth/invalid_code'

        expect(response).not_to be_success
        expect(json['errors']).to include('Not Authenticated')
      end
    end
  end
end
