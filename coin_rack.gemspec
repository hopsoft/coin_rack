# -*- encoding: utf-8 -*-
require "rake"
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coin_rack/version'

Gem::Specification.new do |spec|
  spec.name          = "coin_rack"
  spec.version       = CoinRack::VERSION
  spec.authors       = ["Nathan Hopkins"]
  spec.email         = ["natehop@gmail.com"]
  spec.summary       = "A Simple Rack application that provides a REST interface for Coin."
  spec.homepage      = "https://github.com/hopsoft/coin_rack"

  spec.files = FileList[
    'lib/**/*.rb',
    'bin/*',
    'test/**/*.rb',
    'LICENSE.txt',
    'README.md'
  ].to_a

  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]
end
