# frozen_string_literal: true

require 'tempfile'

RSpec.describe RSpec::DescriptionConsistency::Configuration do
  subject(:configuration) { described_class.send(:new) }

  describe '.instance' do
    it { expect(described_class.instance).to equal(described_class.instance) }
  end

  describe 'enabled=' do
    it { expect { configuration.enabled = true }.not_to raise_error }
    it { expect { configuration.enabled = false }.not_to raise_error }

    specify do
      expect { configuration.enabled = '1' }
        .to raise_error ArgumentError, 'Expected `enabled` to be either `true` or `false`'
    end
  end

  describe 'exit_code=' do
    it { expect { configuration.exit_code = 0 }.not_to raise_error }
    it { expect { configuration.exit_code = 1 }.not_to raise_error }
    it { expect { configuration.exit_code = 239 }.not_to raise_error }

    specify do
      expect { configuration.exit_code = '1' }
        .to raise_error ArgumentError, 'Expected `exit_code` to be an integer between 0 and 255'
    end
  end

  describe 'output_stream=' do
    after do
      configuration.output_stream.close if configuration.output_stream != $stdout
    end

    it { expect { configuration.output_stream = $stdout }.not_to raise_error }
    it { expect { configuration.output_stream = Tempfile.open('test') }.not_to raise_error }
    it { expect { configuration.output_stream = '/tmp/test' }.not_to raise_error }

    specify do
      expect { configuration.output_stream = 1 }
        .to raise_error ArgumentError, 'Unexpected `output_stream` value `1`'
    end
  end
end
