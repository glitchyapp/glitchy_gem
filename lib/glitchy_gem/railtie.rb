require 'rails'

module GlitchyGem
  class Railtie < Rails::Railtie
    initializer "glitchy.use_rack_middleware" do |app|
      app.config.middleware.use "GlitchyGem::Rack"
    end

    config.after_initialize do
      GlitchyGem.configure do |config|
        config.environment ||= Rails.env
        config.logger ||= Rails.logger
        config.url ||= "glitchyapp.com"
      end
    end
  end
end
