# frozen_string_literal: true

module RSpec
  module DescriptionConsistency
    class Reporter
      def initialize(output_stream:)
        @output_stream = output_stream
      end

      def report(state)
        return if state.data.empty?

        output_stream << <<~TXT
          RSpec::DescriptionConsistency detected the following potential inconsistencies:

        TXT

        state.data.each do |key, value|
          output_stream.puts format_violation_entry(key, value)
        end
      end

      private

      attr_reader :output_stream

      def format_violation_entry(key, value)
        value
          .to_a
          .map { "#{_1}: #{key[0]}#{key[1]}" }
          .join("\n")
      end
    end
  end
end
