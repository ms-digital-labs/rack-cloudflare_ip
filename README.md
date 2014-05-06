# Rack::CloudflareIp

Overwrites the `X_FORWARDED_FOR` HTTP header with the contents of
`CF_CONNECTING_IP` if it's present. This makes `request.remote_ip` in
Rails return the IP of the user making the request rather than the IP of
a Cloudflare server.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-cloudflare_ip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-cloudflare_ip

## Usage

In `config/application.rb`:

```ruby
require "rack/cloudflare_ip"
config.middleware.use Rack::CloudflareIp
```

## Contributing

1. Fork it ( http://github.com/ms-digital-labs/rack-cloudflare_ip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
