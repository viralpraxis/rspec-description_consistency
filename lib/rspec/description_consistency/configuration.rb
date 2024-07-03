# frozen_string_literal: true

require 'tempfile'
require 'singleton'

module RSpec
  module DescriptionConsistency
    class Configuration
      include Singleton

      attr_reader :enabled, :exit_code, :output_stream

      def initialize
        @exit_code = 0
        @enabled = true
        @output_stream = RSpec.configuration.output_stream
      end

      def enabled=(value)
        unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
          raise ArgumentError, 'Expected `enabled` to be either `true` or `false`'
        end

        @enabled = value
      end

      def exit_code=(value)
        unless value.is_a?(Integer) && value >= 0 && value <= 255
          raise ArgumentError, 'Expected `exit_code` to be an integer between 0 and 255'
        end

        @exit_code = value
      end

      def output_stream=(value)
        if value.is_a?(IO) || value.is_a?(Tempfile)
          @output_stream = value
        elsif value.is_a?(String)
          @output_stream = File.open(value, 'w')
        else
          raise ArgumentError, "Unexpected `output_stream` value `#{value.inspect}`"
        end
      end
    end
  end
end
