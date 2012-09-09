# -*- encoding: utf-8 -*-
require File.expand_path('../lib/adn/cli/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Balthrop", "Peter Hellberg"]
  gem.email         = ["git@justinbalthrop.com", "peter@c7.se"]
  gem.description   = %q{App.net command line}
  gem.summary       = %q{Command line client for App.net}
  gem.homepage      = "https://github.com/adn-rb/adn-cli"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adn-cli"
  gem.require_paths = ["lib"]
  gem.version       = ADN::CLI::VERSION
end
