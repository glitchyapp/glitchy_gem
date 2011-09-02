module GlitchyGem
  class Glitch
    attr_reader :exception, :controller, :action, :url, :session, :params
    def initialize(e, options = {})
      @rack_env = options[:rack_env] || {}
      @exception = e

      @params = options[:params] || @rack_env['action_dispatch.request.parameters'] || rack_env(:params) || {}
      @url = options[:url] || rack_env(:url)
      @controller = options[:controller] || params['controller']
      @action = options[:action] || params['action']
      @session = options[:session] || @rack_env['rack.session']

      @params = filter_params(@params)

      @uri = URI.parse("http://#{GlitchyGem.url}/glitches?auth_token=#{GlitchyGem.api_key}")
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @request = Net::HTTP::Post.new(@uri.request_uri)
      @request["Content-Type"] = "application/json"
      @request.body = {
        :glitch => e.to_hash.merge({
          :url => @url,
          :params => @params,
          :controller => @controller,
          :action => @action,
          :session => @session,
          :environment => GlitchyGem.environment
        })
      }.to_json
    end

    def send
      return if ignore?
      begin
        @http.request(@request)
      rescue Errno::ECONNREFUSED => e
        GlitchyGem.logger.info "Failed to connect to GlitchyApp. Could not notify about the exception #{self.exception.to_hash.inspect}"
      end
    end

    private

    def ignore?
      !GlitchyGem.environments.include?(GlitchyGem.environment) ||
        GlitchyGem.filter_exceptions.any? {|filter| filter.call(self) }
    end

    def filter_params(params)
      filter_fields = GlitchyGem.filter_params.map(&:upcase)
      filtered_params = {}
      params.each_pair do |k,v|
        if v.class.to_s == "Hash"
          v = filter_params(v)
        end
        filtered_params[k] = filter_fields.include?(k.upcase) ? "[FILTERED]" : v
      end

      filtered_params
    end

    def rack_env(method)
      rack_request.send(method) if rack_request
    rescue
      nil
    end

    def rack_request
      @rack_request ||= ::Rack::Request.new(@rack_env)
    end
  end
end
