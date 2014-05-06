# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rack-cloudflare_ip"
  spec.version       = "1.0.0"
  spec.authors       = ["Pip Taylor"]
  spec.email         = ["pip@evilgeek.co.uk"]
  spec.summary       = %q{Set X-Forwarded-For header to original client IP when using Cloudflare in proxy mode}
  spec.homepage      = "https://github.com/ms-digital-labs/rack-cloudflare_ip"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
end
