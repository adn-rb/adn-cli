# -*- encoding: utf-8 -*-
require File.expand_path('../lib/adn/cli/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Balthrop", "Peter Hellberg"]
  gem.email         = ["git@justinbalthrop.com", "peter@c7.se"]
  gem.description   = %q{App.net command line}
  gem.summary       = %q{Command line client for App.net}
  gem.homepage      = "https://github.com/adn-rb/adn-cli"

  gem.required_ruby_version = '>= 1.9.2'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adn-cli"
  gem.require_paths = ["lib"]
  gem.version       = ADN::CLI::VERSION

  gem.add_runtime_dependency('adn', '~> 0.3.5')
  gem.add_runtime_dependency('ansi', '~> 1.4.3')
end
