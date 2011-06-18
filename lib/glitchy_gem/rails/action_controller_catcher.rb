module GlitchyGem
  module Rails
    module ActionControllerCatcher

      def self.included(base) #:nodoc:
        base.send(:alias_method, :rescue_action_without_glitchy, :rescue_action)
        base.send(:alias_method, :rescue_action, :rescue_action_with_glitchy)
      end

      private

      def rescue_action_with_glitchy(exception)
        error_id = send_glitch(exception, req_data)
        rescue_action_without_glitchy(exception)
      end

      def req_data
        {
          :params           => params.to_hash,
          :session          => session.to_hash,
          :controller       => params[:controller],
          :action           => params[:action],
          :url              => "#{request.protocol}#{request.host}:#{request.port}#{request.request_uri}"
        }
      end

    end
  end
end

def send_glitch(e, req_data)
  glitch = GlitchyGem::Glitch.new(e, req_data)
  glitch.send
end
