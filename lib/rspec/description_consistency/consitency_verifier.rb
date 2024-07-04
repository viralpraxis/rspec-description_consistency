# frozen_string_literal: true

module RSpec
  module DescriptionConsistency
    class ConsitencyVerifier
      def self.call(...)
        new(...).call
      end

      def initialize(context:, configuration:)
        @context = context
        @configuration = configuration
      end

      def call # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        return unless top_level_example_group?(context)
        return unless (method_example_group_context = find_method_description_example_group(context))

        description = method_example_group_context[:description]

        klass = if context[:described_class].is_a?(String)
          ::Object.const_get(method_example_group_context[:described_class])
        else
          context[:described_class]
        end

        include_private = method_example_group_context[:private]

        return if method_example_group_context[:description_consistency] == false
        return if correct_method_example_group?(description, klass, include_private: include_private)

        Thread.current[EVALUATION_PERSISTENCE_KEY].add_entry(
          class_name: klass,
          method_name: description,
          payload: method_example_group_context[:location]
        )
      end

      private

      attr_reader :context, :configuration

      def correct_method_example_group?(description, klass, include_private:)
        method_name = description[1..].to_sym

        if description.start_with?('#')
          return true if klass.instance_methods.include?(method_name)
          return false unless include_private
          return true if klass.private_instance_methods.include?(method_name)

          klass.respond_to?(:attribute_names) && klass.attribute_names.include?(method_name.to_s)
        elsif description.start_with?('.')
          correct_class_method?(method_name, klass, include_private: include_private)
        end
      end

      def correct_class_method?(method_name, klass, include_private:)
        klass.singleton_class.instance_methods.include?(method_name) ||
          (include_private && klass.singleton_class.private_instance_methods.include?(method_name)) ||
          activesupport_concern?(method_name, klass)
      end

      def activesupport_concern?(method_name, klass)
        if klass.is_a?(Module) && klass.const_defined?(:ClassMethods) &&
           klass.const_get(:ClassMethods).instance_methods.include?(method_name)
          true
        else
          Object.const_defined?(:ActiveSupport) && ::ActiveSupport.const_defined?(:Concern) &&
            klass.is_a?(ActiveSupport::Concern) &&
            ::Object.const_get(klass.name.split('::').first).respond_to?(method_name)
        end
      end

      def top_level_example_group?(context)
        described_class = context[:described_class]

        return true if described_class.is_a?(Module)
        return true if described_class.is_a?(String) && ::Object.const_defined?(described_class)

        false
      end

      def find_method_description_example_group(context)
        loop do
          return context if context.nil? || context[:description].start_with?('.', '#')

          context = if context.key?(:example_group)
            context[:example_group]
          else
            context[:parent_example_group]
          end
        end
      end
    end
  end
end
