# frozen_string_literal: true

require_relative 'description_consistency/configuration'
require_relative 'description_consistency/consitency_verifier'
require_relative 'description_consistency/reporter'
require_relative 'description_consistency/resource_manager'
require_relative 'description_consistency/state'

module RSpec
  module DescriptionConsistency
    EVALUATION_PERSISTENCE_KEY = :'__rspec-description_consistency'

    class << self
      def configuration
        ::RSpec::DescriptionConsistency::Configuration.instance
      end

      def configure
        yield configuration
      end

      def bind(config) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
        config.before(:suite) do
          Thread.current[EVALUATION_PERSISTENCE_KEY] = ::RSpec::DescriptionConsistency::State.new
        end

        config.before do |example|
          configuration = ::RSpec::DescriptionConsistency::Configuration.instance
          next unless configuration.enabled

          ::RSpec::DescriptionConsistency::ConsitencyVerifier.call(
            context: example.metadata, configuration: configuration
          )
        rescue StandardError => e
          configuration.error_stream.puts "Encountered unexpected exception: #{e.inspect}"
        end

        config.after(:suite) do
          configuration = ::RSpec::DescriptionConsistency::Configuration.instance

          ::RSpec::DescriptionConsistency::Reporter.new(
            output_stream: ::RSpec::DescriptionConsistency::Configuration.instance.output_stream
          ).report(Thread.current[EVALUATION_PERSISTENCE_KEY])

          unless [RSpec.configuration.error_stream,
                  RSpec.configuration.error_stream].include?(configuration.output_stream)
            ::RSpec::DescriptionConsistency::ResourceManager.release_io(RSpec.configuration.output_stream)
          end

          next unless Thread.current[EVALUATION_PERSISTENCE_KEY].any?

          exit configuration.exit_code if configuration.exit_code.positive?
        end
      end
    end
  end
end
