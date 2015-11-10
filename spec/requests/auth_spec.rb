require 'rails_helper'
require 'support/request_helpers'

RSpec.describe 'Auth:', type: :request do
  describe 'GET /auth' do
    before(:each) do 
      allow(InstagramWrapper).to receive(:id_for).and_return(id_response)
    end

    let(:id_response) { 123456 }
    let!(:existing_user) { FactoryGirl.create(:user) }
    let(:new_user) { FactoryGirl.build(:user, id: id_response) }
    let(:user_count) { User.count }

    it 'creates a user for first time login' do
      allow(InstagramWrapper).to receive(:profile).and_return(new_user)
      get '/auth/valid_code'

      expect(response).to be_success
      expect(json).to have_key('token')
      expect(user_count).to eq(2)
    end

    it 'returns user for existing user' do
      allow(InstagramWrapper).to receive(:profile).and_return(existing_user)
      get '/auth/valid_code'

      expect(response).to be_success
      expect(json).to have_key('token')
      expect(user_count).to eq(1)
    end
  end
end
