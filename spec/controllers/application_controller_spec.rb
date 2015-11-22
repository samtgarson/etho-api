require 'rails_helper'

describe ApplicationController do
  controller do
    before_action :authenticate_request!
    def index
      render text: 'Hello world!'
    end
  end

  describe '#authenticate_request!' do
    let!(:current_user) { FactoryGirl.create(:user) }
    before(:each) do
      @request.headers['Authorization'] = custom_headers
      get :index
    end

    context 'given a valid authentication token' do
      let(:custom_headers) { authentication_headers }
      it 'assigns current user' do
        expect(response).to be_success
      end
    end

    context 'given an expired authentication token' do
      let(:custom_headers) { expired_authentication_headers }
      it 'raises a timeout error' do
        expect(json['errors']).to include 'Authentication Timeout'
        expect(response).not_to be_success
      end
    end

    context 'given an invalid authentication token' do
      let(:custom_headers) { invalid_authentication_headers }
      it 'raises an authentication error' do
        expect(json['errors']).to include 'Not Authenticated'
        expect(response).not_to be_success
      end
    end
  end
end
