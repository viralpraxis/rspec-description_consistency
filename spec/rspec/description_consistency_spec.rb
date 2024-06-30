# frozen_string_literal: true

RSpec.describe Rspec::DescriptionConsistency do
  before do
    Thread.current[RSpec::DescriptionConsistency::EVALUATION_PERSISTENCE_KEY] = RSpec::DescriptionConsistency::State.new

    RSpec::DescriptionConsistency.configure do |configurer|
      configurer.output_stream = StringIO.new
    end

    RSpec.configure do |config|
      RSpec::DescriptionConsistency.bind(config)
    end
  end

  it 'detects violation' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    example_group = RSpec::Core::ExampleGroup.describe Integer do
      describe '#times' do
        it { expect(3.times).to be_an_instance_of(Enumerator) }
      end

      describe '#foobar' do
        it { expect(1 + 1).not_to respond_to(:foobar) }
      end
    end

    example_group.new

    expect(RSpec::DescriptionConsistency.configuration.output_stream.read).to be_empty
  end
end
