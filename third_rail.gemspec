# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "third_rail/version"

Gem::Specification.new do |spec|
  spec.name          = "third_rail"
  spec.version       = ThirdRail::VERSION
  spec.authors       = ["Dan Cheail"]
  spec.email         = ["dan@undumb.com"]
  spec.summary       = %q{Ruby-based template generator. (Placeholding.)}
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "tilt", "~> 2.0"
  spec.add_dependency "erubis", "~> 2.7.0"
  spec.add_dependency "activemodel", ">= 4.0.0", "< 4.1"
  spec.add_dependency "actionpack", ">= 4.0.0", "< 4.1"
  spec.add_dependency "activesupport", ">= 4.0.0", "< 4.1"


  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta1"
  spec.add_development_dependency "capybara", "~> 2.2.1"
  spec.add_development_dependency "haml", "~> 4.0.3"
  spec.add_development_dependency "rake"

  # becuse I"m lazy.
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"


end
