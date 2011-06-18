require 'glitchy_gem/rails/action_controller_catcher'

module GlitchyGem
  module Rails
    def self.initialize
      if defined?(ActionController::Base)
        ActionController::Base.send(:include, GlitchyGem::Rails::ActionControllerCatcher)
      end

      if defined?(::Rails.configuration) && ::Rails.configuration.respond_to?(:middleware)
        ::Rails.configuration.middleware.insert_after 'ActionController::Failsafe', GlitchyGem::Rack
      end

      if defined?(::Rails.logger)
        rails_logger = ::Rails.logger
      elsif defined?(RAILS_DEFAULT_LOGGER)
        rails_logger = RAILS_DEFAULT_LOGGER
      end

      GlitchyGem.configure do |config|
        config.environment ||= RAILS_ENV if defined?(RAILS_ENV)
        config.logger ||= rails_logger
        config.url ||= "glitchyapp.com"
      end
    end
  end
end

GlitchyGem::Rails.initialize
