require 'net/http'
require 'uri'

module GlitchyGem
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => e
        send_glitch(e, env)
        raise
      end

      if env['rack.exception']
        send_glitch(env['rack.exception'], env)
      end

      response
    end
  end
end

def send_glitch(e, env)
  glitch = GlitchyGem::Glitch.new(e, :rack_env => env)
  glitch.send
end
