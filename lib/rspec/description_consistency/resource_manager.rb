# frozen_string_literal: true

module RSpec
  module DescriptionConsistency
    module ResourceManager
      module_function

      def release_io(io)
        return unless io
        return if [$stdout, $stderr].include?(io)
        return if io.closed?
        return if io.is_a?(StringIO) || (defined?(RSpec::Core::OutputWrapper) && io.is_a?(RSpec::Core::OutputWrapper))

        io.close
      end
    end
  end
end
