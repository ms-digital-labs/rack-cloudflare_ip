require 'spec_helper'

describe Rack::CloudflareIp do
  include Rack::Test::Methods

  def app
    Rack::CloudflareIp.new(base_app)
  end

  def base_app
    lambda { |env|
      headers = env.select { |k, _| k =~ /^(HTTP_|ORIGINAL_|REMOTE_)/ }
      [200, headers, []]
    }
  end

  before do
    get "/", nil, headers
  end

  context "with HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "HTTP_CF_CONNECTING_IP" => "123.123.123.123",
      "HTTP_X_FORWARDED_FOR" => "234.234.234.234",
      "REMOTE_ADDR" => "222.222.222.222",
    } }

    it "overwrites the HTTP_X_FORWARDED_FOR header" do
      expect(last_response.headers["HTTP_X_FORWARDED_FOR"])
        .to eq("123.123.123.123")
    end

    it "saves the original header in HTTP_ORIGINAL_X_FORWARDED_FOR" do
      expect(last_response.headers["HTTP_ORIGINAL_X_FORWARDED_FOR"])
              .to eq("234.234.234.234")
    end

    it "leaves the remote address alone" do
      expect(last_response.headers["REMOTE_ADDR"]).to eq("222.222.222.222")
    end
  end

  context "without HTTP_CF_CONNECTING_IP header" do
    let(:headers) { {
      "HTTP_X_FORWARDED_FOR" => "234.234.234.234"
    } }

    it "doesn't modify the HTTP_X_FORWARDED_FOR header" do
      expect(last_response.headers["HTTP_X_FORWARDED_FOR"])
        .to eq("234.234.234.234")
    end
  end

  context "with override_remote_address set" do
    def app
      Rack::CloudflareIp.new(base_app, override_remote_address: true)
    end

    context "with HTTP_CF_CONNECTING_IP header" do
      let(:headers) { {
        "HTTP_CF_CONNECTING_IP" => "123.123.123.123",
        "REMOTE_ADDR" => "234.234.234.234",
        "HTTP_X_FORWARDED_FOR" => "234.234.234.234",
      } }

      it "overwrites the REMOTE_ADDR env var" do
        expect(last_response.headers["REMOTE_ADDR"]).to eq("123.123.123.123")
      end

      it "saves the original header in ORIGINAL_REMOTE_ADDR" do
        expect(last_response.headers["ORIGINAL_REMOTE_ADDR"])
          .to eq("234.234.234.234")
      end

      it "purges the HTTP_X_FORWARDED_FOR header" do
        expect(last_response.headers["HTTP_X_FORWARDED_FOR"]).to be_nil
      end

      it "stashes the old HTTP_X_FORWARDED_FOR in HTTP_ORIGINAL_X_FORWARDED_FOR" do
        expect(last_response.headers["HTTP_ORIGINAL_X_FORWARDED_FOR"])
          .to eq("234.234.234.234")
      end
    end

    context "without HTTP_CF_CONNECTING_IP header" do
      let(:headers) { {
        "REMOTE_ADDR" => "234.234.234.234"
      } }

      it "doesn't modify the HTTP_X_FORWARDED_FOR header" do
        expect(last_response.headers["REMOTE_ADDR"]).to eq("234.234.234.234")
      end
    end
  end
end
