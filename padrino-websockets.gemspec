# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'padrino-websockets/version'

Gem::Specification.new do |spec|
  spec.name          = "padrino-websockets"
  spec.version       = Padrino::Websockets::VERSION
  spec.authors       = ["Darío Javier Cravero"]
  spec.email         = ["dario@uxtemple.com"]
  spec.summary       = %q{A WebSockets abstraction for Padrino}
  spec.description   = %q{A WebSockets abstraction for the Padrino Ruby Web Framework to manage
    channels, users and events regardless of the underlying WebSockets implementation.}
  spec.homepage      = "https://github.com/dariocravero/padrino-websockets"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
