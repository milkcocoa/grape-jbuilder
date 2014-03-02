# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/jbuilder/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-jbuilder"
  spec.version       = Grape::Jbuilder::VERSION
  spec.authors       = ["Shu Masuda"]
  spec.email         = ["masushu@gmail.com"]
  spec.description   = %q{Use Jbuilder in Grape}
  spec.summary       = %q{Use Jbuilder in Grape}
  spec.homepage      = "https://github.com/milkcocoa/grape-jbuilder"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "grape", ">= 0.3"
  spec.add_dependency "jbuilder"
  spec.add_dependency "tilt"
  spec.add_dependency "tilt-jbuilder", ">= 0.4.0"
  spec.add_dependency "i18n"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "json_expressions"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
