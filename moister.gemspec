# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moister/version'

Gem::Specification.new do |spec|
  spec.name          = "moister"
  spec.version       = Moister::VERSION
  spec.authors       = ["James Pike"]
  spec.email         = ["github@chilon.net"]

  spec.summary       = %q{An OptionParser wrapper that supports subcommands and shorter syntax.}
  spec.description   = spec.summary
  spec.homepage      = "http://github.com/ohjames/moister"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4"

  spec.add_dependency "bundler", "~> 2.0"
end
