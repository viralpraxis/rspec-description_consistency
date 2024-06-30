# frozen_string_literal: true

require 'set'
require 'singleton'

module RSpec
  module DescriptionConsistency
    class State
      attr_reader :data

      def initialize
        @data = {}
      end

      def any?
        @data.any?
      end

      def add_entry(class_name:, method_name:, payload:)
        (data[[class_name, method_name]] ||= Set.new) << payload
      end
    end
  end
end
