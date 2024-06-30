# frozen_string_literal: true

RSpec.describe RSpec::DescriptionConsistency::Reporter do
  describe '#report' do
    subject(:reporter) { described_class.new(output_stream: $stdout) }

    def perform(state)
      reporter.report(state)
    end

    context 'with violations' do
      let(:state) do
        RSpec::DescriptionConsistency::State.new.tap do |state|
          state.add_entry(class_name: Kernel, method_name: :'.puts', payload: 'some-path-1')
          state.add_entry(class_name: Kernel, method_name: :'.print', payload: 'some-path-2')
        end
      end

      let(:expected_output) do
        <<~TXT
          RSpec::DescriptionConsistency detected the following potential inconsistencies:

          some-path-1: Kernel.puts
          some-path-2: Kernel.print
        TXT
      end

      specify do
        expect { perform(state) }.to output(expected_output).to_stdout
      end

      it { expect { perform(state) }.not_to output.to_stderr }
    end

    context 'without violations' do
      let(:state) { RSpec::DescriptionConsistency::State.new }

      it { expect { perform(state) }.not_to output.to_stdout }
      it { expect { perform(state) }.not_to output.to_stderr }
    end
  end
end
