require "rack"

module Rack
  class CloudflareIp
    def initialize(app)
      @app = app
    end

    def call(env)
      if env.has_key?("HTTP_CF_CONNECTING_IP")
        env["HTTP_ORIGINAL_X_FORWARDED_FOR"] = env["HTTP_X_FORWARDED_FOR"]
        env["HTTP_X_FORWARDED_FOR"] = env["HTTP_CF_CONNECTING_IP"]
      end
      @app.call(env)
    end
  end
end
