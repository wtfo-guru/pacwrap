# frozen_string_literal: true

require_relative 'lib/pacwrap/version'

Gem::Specification.new do |spec|
  spec.name          = 'pacwrap'
  spec.version       = Pacwrap::VERSION
  spec.authors       = ['Quien Sabe']
  spec.email         = ['qs5779@mail.com']

  spec.summary       = 'gem to wrap os specific package manager actions'
  spec.description   = 'standardizes package manage actions across various linux distrols'
  spec.homepage      = 'https://github.com/wtfo-guru/pacwrap'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.10')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGLOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'bundler-geminabox'
  spec.add_development_dependency 'ffi'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'

  spec.add_runtime_dependency 'facter'
  spec.add_runtime_dependency 'logging'
  spec.add_runtime_dependency 'thor'
end
