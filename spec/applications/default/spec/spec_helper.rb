# frozen_string_literal: true

require 'rspec/description_consistency'

require_relative File.expand_path('../app/star', __dir__)

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  RSpec::DescriptionConsistency.bind config
end

RSpec::DescriptionConsistency.configure do |config|
  config.exit_code = 1
end
