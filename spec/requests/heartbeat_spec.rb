require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  before do
    set_subdomain
  end

  describe 'GET /heartbeat' do
    it 'returns a pulse' do
      get heartbeat_path
      expect(response).to have_http_status(200)
      expect(json['heartbeat']).to be_truthy
    end
  end

  describe 'GET /' do
    it 'returns a greeting' do
      get api_root_path
      expect(response).to have_http_status(200)
      expect(json['etho']).to eq 'Hello, human.'
    end
  end
end
