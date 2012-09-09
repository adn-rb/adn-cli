# -*- encoding: utf-8 -*-
require File.expand_path('../lib/adn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Balthrop"]
  gem.email         = ["git@justinbalthrop.com"]
  gem.description   = %q{App.net command line}
  gem.summary       = %q{Command line client for App.net}
  gem.homepage      = "http://github.com/ninjudd/adn"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adn"
  gem.require_paths = ["lib"]
  gem.version       = Adn::VERSION
end
