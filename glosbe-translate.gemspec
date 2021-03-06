# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "glosbe/version"

Gem::Specification.new do |spec|
  spec.name          = "glosbe-translate"
  spec.version       = Glosbe::VERSION
  spec.authors       = ["Kevin McPhillips"]
  spec.email         = ["github@kevinmcphillips.ca"]

  spec.summary       = %q{Use https://glosbe.com to translate and define words and phrases}
  spec.description   = %q{Wrapper around the JSON api on the Glosbe online multilingual dictionary. Return definitions and translations.}
  spec.homepage      = "https://github.com/kmcphillips/glosbe-translate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.15"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
