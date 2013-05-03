# -*- encoding: utf-8 -*-
require File.join(File.expand_path("../lib", __FILE__), "coin_rack", "version")

Gem::Specification.new do |gem|
  gem.name          = "coin_rack"
  gem.version       = CoinRack::VERSION
  gem.authors       = ["Nathan Hopkins"]
  gem.email         = ["natehop@gmail.com"]
  gem.summary       = "A Simple Rack application that provides a REST interface for Coin."
  gem.homepage      = "https://github.com/hopsoft/coin_rack"

  gem.add_dependency "rack"
  gem.add_dependency "coin"
  gem.add_dependency "footing"
  gem.add_dependency "rack-abstract-format"
  gem.add_dependency "rack-accept-media-types"
  gem.add_dependency "builder"
  gem.add_dependency "activesupport"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-stack_explorer"
  gem.add_development_dependency "micro_test"

  gem.files = Dir["lib/**/*.rb", "bin/*", "[A-Z].*", "config.ru"]
  gem.test_files = Dir["test/**/*.rb"]

  gem.executables   = ["coin_rack"]
end
