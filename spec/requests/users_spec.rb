require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /user' do
    let!(:user) { FactoryGirl.create(:user) }
    before { mock_authorization }

    it 'works! (now write some real specs)' do
      get user_path(id: user.id)
      expect(json["_id"]).to eq(user.id)
      expect(response).to have_http_status(200)
    end
  end
end
