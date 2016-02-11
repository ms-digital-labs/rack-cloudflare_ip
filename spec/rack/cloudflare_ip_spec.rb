require 'spec_helper'

describe Rack::CloudflareIp do
  include Rack::Test::Methods

  def app
    Rack::CloudflareIp.new(base_app)
  end

  def base_app
    lambda { |env|
      [200, env, []]
    }
  end

  before do
    get "/", nil, headers
  end

  context "with HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "HTTP_CF_CONNECTING_IP" => "123.123.123.123",
      "REMOTE_ADDR" => "234.234.234.234"
    } }

    it "overwrites sets the REMOTE_ADDR header" do
      puts last_response.headers
      expect(last_response.headers["REMOTE_ADDR"]).to eq("123.123.123.123")
    end

    it "saves the original header in ORIGINAL_REMOTE_ADDR" do
      expect(last_response.headers["ORIGINAL_REMOTE_ADDR"])
              .to eq("234.234.234.234")
    end
  end

  context "without HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "REMOTE_ADDR" => "234.234.234.234"
    } }

    it "doesn't modify the REMOTE_ADDR header" do
      expect(last_response.headers["REMOTE_ADDR"]).to eq("234.234.234.234")
    end
  end
end
