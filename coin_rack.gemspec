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

  spec.add_dependency "rack"
  spec.add_dependency "coin"
  spec.add_dependency "footing"
  spec.add_dependency "rack-abstract-format"
  spec.add_dependency "rack-accept-media-types"
  spec.add_dependency "activesupport"

  spec.files = FileList[
    "lib/**/*.rb",
    "bin/*",
    "test/**/*.rb",
    "config.ru",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md"
  ].to_a

  spec.executables   = ["coin_rack"]
end
