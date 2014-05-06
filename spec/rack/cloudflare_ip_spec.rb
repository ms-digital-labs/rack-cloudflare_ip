require 'spec_helper'

describe Rack::CloudflareIp do
  include Rack::Test::Methods

  def app
    Rack::CloudflareIp.new(base_app)
  end

  def base_app
    lambda { |env|
      headers = env.select { |k, _| k =~ /^HTTP_.*/ }
      [200, headers, []]
    }
  end

  before do
    get "/", nil, headers
  end

  context "with HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "HTTP_CF_CONNECTING_IP" => "123.123.123.123",
      "HTTP_X_FORWARDED_FOR" => "234.234.234.234"
    } }

    it "overwrites the HTTP_X_FORWARDED_FOR header" do
      expect(last_response.headers["HTTP_X_FORWARDED_FOR"]).to eq("123.123.123.123")
    end

    it "saves the original header in HTTP_ORIGINAL_X_FORWARDED_FOR" do
      expect(last_response.headers["HTTP_ORIGINAL_X_FORWARDED_FOR"])
              .to eq("234.234.234.234")
    end
  end

  context "without HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "HTTP_X_FORWARDED_FOR" => "234.234.234.234"
    } }

    it "doesn't modify the HTTP_X_FORWARDED_FOR header" do
      expect(last_response.headers["HTTP_X_FORWARDED_FOR"]).to eq("234.234.234.234")
    end
  end
end
