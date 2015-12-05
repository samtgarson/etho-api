require 'rails_helper'

RSpec.describe UsersController, type: :request do
  before do
    set_subdomain
  end

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

  methods = {
    time: %w(time_of_day season),
    colours: %w(colours favourite_colour),
    tags: %w(tags)
  }

  describe 'GET /user/:id/stats/' do
    mock_authorization

    context 'on a user with no images' do
      it 'returns the correct statistics' do
        get stats_path('self')

        expect(response).to be_success
        expect(json['errors']).to include 'User has no images.'
      end
    end

    context 'on a user with images' do
      let(:result) { 'statistic' }
      before do
        stub = UserStatisticsService.instance_methods(false).each_with_object({}) do |m, h|
          h[m] = result
        end
        allow_any_instance_of(UserStatisticsService).to receive_messages(stub)
      end

      it 'returns the correct statistics' do
        get stats_path('self')
        expect(response).to be_success
        expect(json.keys).to match_array methods.values.flatten
      end
    end
  end

  methods.keys.each do |method|
    describe "GET /user/:id/stats/#{method}" do
      mock_authorization

      let(:current_path) { send "#{method}_path", 'self' }
      context 'on a user with no images' do
        it 'returns the correct statistics' do
          get current_path

          expect(response).to be_success
          expect(json['errors']).to include 'User has no images.'
        end
      end

      context 'on a user with images' do
        let(:result) { 'statistic' }
        before do
          stub = UserStatisticsService.instance_methods(false).each_with_object({}) do |m, h|
            h[m] = result
          end
          allow_any_instance_of(UserStatisticsService).to receive_messages(stub)
        end

        it 'returns the correct statistics' do
          get current_path
          expect(response).to be_success
          expect(json.keys).to match_array methods[method]
          expect(json.values).to all eq result
        end
      end
    end
  end
end
