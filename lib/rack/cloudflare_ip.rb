require "rack"

module Rack
  class CloudflareIp
    def initialize(app, override_remote_address: false)
      @app = app
      @override_remote_address = override_remote_address
    end

    def call(env)
      if env.has_key?("HTTP_CF_CONNECTING_IP")
        if @override_remote_address
          env["ORIGINAL_REMOTE_ADDR"] = env["REMOTE_ADDR"]
          env["REMOTE_ADDR"] = env["HTTP_CF_CONNECTING_IP"]
        else
          env["HTTP_ORIGINAL_X_FORWARDED_FOR"] = env["HTTP_X_FORWARDED_FOR"]
          env["HTTP_X_FORWARDED_FOR"] = env["HTTP_CF_CONNECTING_IP"]
        end
      end
      @app.call(env)
    end
  end
end
