# frozen_string_literal: true

require 'open3'

RSpec.describe Rspec::DescriptionConsistency do
  specify do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
    stdout, stderr, status = Open3.capture3 <<~TXT
      bash -c "cd spec/applications/default && bundle exec rspec"
    TXT

    expect(status.exitstatus).to eq(1)
    expect(stdout).to include <<~TXT
      RSpec::DescriptionConsistency detected the following potential inconsistencies:

      ./spec/star_spec.rb:10: Star.rebuild
      ./spec/star_spec.rb:14: Star.some_class_privates1
      ./spec/star_spec.rb:30: Star#latitude
      ./spec/star_spec.rb:34: Star#some_privates

    TXT
    expect(stderr).to be_empty
  end
end
