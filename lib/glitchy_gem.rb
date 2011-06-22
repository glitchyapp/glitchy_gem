require 'glitchy_gem/patches'
require 'glitchy_gem/glitch'
require 'glitchy_gem/rack'
require 'glitchy_gem/railtie' if defined?(Rails::Railtie)

module GlitchyGem
  class << self
    attr_accessor :api_key, :environment, :logger, :url, :environments
    def configure
      yield(self)

      self.environments ||= ["production"]
    end
  end
end
