# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utm_logs/version'

Gem::Specification.new do |spec|
  spec.name          = "utm_logs"
  spec.version       = UtmLogs::VERSION
  spec.authors       = ["Dmitry Ilyin"]
  spec.email         = ["idv1985@gmail.com"]
  spec.summary       = 'UTM5 netflow log processing tools'
  spec.description   = 'Several tools to archive and parse UTM5 netflow dumps'
  spec.homepage      = "https://github.com/dmitryilyin/utm_logs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
