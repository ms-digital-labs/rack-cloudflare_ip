require "rack"

module Rack
  class CloudflareIp
    def initialize(app)
      @app = app
    end

    def call(env)
      if env.has_key?("HTTP_CF_CONNECTING_IP")
        env["ORIGINAL_REMOTE_ADDR"] = env["REMOTE_ADDR"]
        env["REMOTE_ADDR"] = env["HTTP_CF_CONNECTING_IP"]
      end
      @app.call(env)
    end
  end
end
