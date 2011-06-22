module GlitchyGem
  class Glitch
    attr_reader :exception
    def initialize(e, options = {})
      @rack_env = options[:rack_env] || {}
      @exception = e

      params = options[:params] || @rack_env['action_dispatch.request.parameters'] || rack_env(:params)
      url = options[:url] || rack_env(:url)
      controller = options[:controller] || params['controller']
      action = options[:action] || params['action']
      session = options[:session] || @rack_env['rack.session']

      @uri = URI.parse("http://#{GlitchyGem.url}/glitches?auth_token=#{GlitchyGem.api_key}")
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @request = Net::HTTP::Post.new(@uri.request_uri)
      @request["Content-Type"] = "application/json"
      @request.body = { :glitch => e.to_hash.merge({ :url => url, :params => params, :controller => controller, :action => action, :session => session, :environment => GlitchyGem.environment }) }.to_json
    end

    def send
      return unless GlitchyGem.environments.include?(GlitchGem.environment)
      begin
        @http.request(@request)
      rescue Errno::ECONNREFUSED => e
        GlitchyGem.logger.info "Failed to connect to GlitchyApp. Could not notify about the exception #{self.exception.to_hash.inspect}"
      end
    end

    private

    def rack_env(method)
      rack_request.send(method) if rack_request
    end

    def rack_request
      @rack_request ||= ::Rack::Request.new(@rack_env)
    end
  end
end
