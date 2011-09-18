module GlitchyGem
  class Glitch
    attr_reader :exception, :controller, :action, :url, :session, :params
    def initialize(e, options = {})
      @rack_env = options[:rack_env] || {}
      @exception = e

      @params = get_filtered_params(options[:params])
      @url = get_url(options[:url])
      @controller = get_controller(options[:controller])
      @action = get_action(options[:action])
      @session = get_session(options[:session])

      @request = Net::HTTP::Post.new(uri.request_uri)
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

    def connection
      return @connection if @connection
      @connection = Net::HTTP.new(uri.host, uri.port)
    end

    def send
      return if ignore?
      begin
        connection.request(@request)
      rescue Errno::ECONNREFUSED => e
        GlitchyGem.logger.info "Failed to connect to GlitchyApp. Could not notify about the exception #{self.exception.to_hash.inspect}"
      end
    end

    private

    def uri
      @uri ||= URI.parse("http://#{GlitchyGem.url}/glitches?auth_token=#{GlitchyGem.api_key}")
    end

    def get_filtered_params(params_from_options)
      filter_params(get_params(params_from_options))
    end

    def get_params(params_from_options)
      params_from_options || @rack_env['action_dispatch.request.parameters'] || rack_env(:params) || {}
    end

    def get_url(url_from_options)
      url_from_options || rack_env(:url)
    end

    def get_controller(controller_from_options)
      controller_from_options || @params['controller']
    end

    def get_action(action_from_options)
      action_from_options || params['action']
    end

    def get_session(session_from_options)
      session_from_options || @rack_env['rack.session']
    end

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
