require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

begin
  ENV.update YAML.load_file('config/application.yml')[Rails.env]
rescue
  {}
end

module EthoApi
  class Application < Rails::Application
    Mongo::Logger.logger.level = Logger::INFO
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.enabled = false

    config.exceptions_app = routes

    config.generators do |g|
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.test_framework :rspec, controller_specs: false, routing_specs: false
    end

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end
