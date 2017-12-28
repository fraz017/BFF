require_relative 'boot'

require 'rails/all'
require 'csv'
require 'iconv'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SuggestMe
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    config.active_job.queue_adapter = :delayed_job
    # -- all .rb files in that directory are automatically loaded.
    config_keys = File.join(Rails.root, 'config', 'config.yml')
    CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(config_keys)))[Rails.env]
    CONFIG.each do |k,v|
      ENV[k.upcase] ||= v
    end

    config.to_prepare do
      Devise::SessionsController.layout "devise"
      Devise::RegistrationsController.layout "devise"
    end
  end
end
