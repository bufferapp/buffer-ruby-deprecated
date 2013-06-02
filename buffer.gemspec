# -*- encoding: utf-8 -*-
require File.expand_path('../lib/buffer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tom Ashworth"]
  gem.email         = ["tom@phuu.net"]
  gem.description   = "Buffer API wrapper for Ruby"
  gem.summary       = "Buffer API wrapper for Ruby"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "buffer"
  gem.require_paths = ["lib"]
  gem.version       = Buffer::VERSION

  gem.add_dependency "faraday"
  gem.add_dependency "multi_json"
  gem.add_dependency "i18n"
  gem.add_dependency "activesupport"

  gem.add_development_dependency "rspec", "~> 2.7"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "webmock"
end
