module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
  module AuthHelpers
    def mock_authorization
      allow_any_instance_of(ApplicationController).to receive(:authenticate_request!).and_return(true)
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
  config.include Requests::AuthHelpers, type: :request
end