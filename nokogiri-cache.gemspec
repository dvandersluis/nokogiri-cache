# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nokogiri/cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'nokogiri-cache'
  spec.version       = Nokogiri::Cache::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['daniel.vandersluis@gmail.com']

  spec.summary       = %q{Allow Rails to cache fragments of XML built by nokogiri}
  spec.description   = %q{Allow Rails to cache fragments of XML built by nokogiri}
  spec.homepage      = 'https://www.github.com/dvandersluis/nokogiri-cache'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'benchmark-ips'

  spec.add_dependency 'rails', '~> 3.0'
  spec.add_dependency 'nokogiri', '~> 1.6.7'
end
