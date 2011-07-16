require 'glitchy_gem/patches'
require 'glitchy_gem/glitch'
require 'glitchy_gem/rack'
require 'glitchy_gem/railtie' if defined?(Rails::Railtie)

module GlitchyGem
  class << self
    # These are the attributes a user can set in their config file.
    attr_accessor :api_key, :environment, :logger, :url, :environments, :filter_params, :filter_exceptions
    def configure
      self.filter_exceptions ||= [
        lambda{|glitch| 
          [
            'ActiveRecord::RecordNotFound',
            'ActionController::RoutingError',
            'ActionController::InvalidAuthenticityToken',
            'ActionController::UnknownAction'
          ].include?(glitch.exception.class)
        }
      ]

      self.filter_params ||= ["password", "password_confirmation"]
      self.environments ||= ["production"]

      yield(self)
    end
  end
end
