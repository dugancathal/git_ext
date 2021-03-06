lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_ext/version'

Gem::Specification.new do |spec|
  spec.name          = "git_ext"
  spec.version       = GitExt::VERSION
  spec.authors       = ["TJ Taylor"]
  spec.email         = ["dugancathal@gmail.com"]
  spec.description   = %q{Some git scripts}
  spec.summary       = %q{A few git scripts to make git'ting easier for pairs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
