# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'menuboy/version'

Gem::Specification.new do |spec|
  spec.name          = "menuboy"
  spec.version       = Menuboy::VERSION
  spec.authors       = ["Keyvan Fatehi"]
  spec.email         = ["keyvanfatehi@gmail.com"]
  spec.description   = %q{Command-line menu building DSL}
  spec.summary       = %q{Command-line menu building DSL}
  spec.homepage      = "https://github.com/keyvanfatehi/menuboy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
