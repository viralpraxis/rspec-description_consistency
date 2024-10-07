# frozen_string_literal: true

require_relative 'lib/rspec/description_consistency/version'

Gem::Specification.new do |spec|
  spec.name = 'rspec-description_consistency'
  spec.version = Rspec::DescriptionConsistency::VERSION
  spec.authors = ['Iaroslav Kurbatov']
  spec.email = ['iaroslav2k@gmail.com']

  spec.summary = 'RSpec extension for automatic description consistency verification'
  spec.description = <<~TXT
    Automatic checking of consistency of descriptions in context and describe blocks, and class or module methods.
  TXT
  spec.homepage = 'https://github.com/viralpraxis/rspec-description_consistency'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = 'https://github.com/viralpraxis/rspec-description_consistency'
  spec.metadata['changelog_uri'] = 'https://github.com/viralpraxis/rspec-description_consistency/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ spec/ .git .github])
    end
  end

  spec.require_paths = ['lib']
end
