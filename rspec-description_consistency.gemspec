# frozen_string_literal: true

require_relative 'lib/rspec/description_consistency/version'

Gem::Specification.new do |spec|
  spec.name = 'rspec-description_consistency'
  spec.version = Rspec::DescriptionConsistency::VERSION
  spec.authors = ['Iaroslav Kurbatov']
  spec.email = ['iaroslav2k@gmail.com']

  spec.summary = 'Write a short summary, because RubyGems requires one.'
  spec.description = 'Write a longer description or delete this line.'
  spec.homepage = 'https://github.com/viralpraxis/rspec-description_consistency'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/viralpraxis/rspec-description_consistency'
  spec.metadata['changelog_uri'] = 'https://github.com/viralpraxis/rspec-description_consistency/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
