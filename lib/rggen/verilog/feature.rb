# frozen_string_literal: true

module RgGen
  module Verilog
    class Feature < SystemVerilog::RTL::Feature
      private

      def create_variable(data_type, attributes, &block)
        attributes = attributes.merge(array_format: :serialized)
        super
      end

      def create_argument(direction, attributes, &block)
        attributes =
          attributes
            .reject { |key, _| key == :data_type }
            .merge(array_format: :serialized)
        super
      end

      def create_parameter(parameter_type, attributes, &block)
        attributes = attributes.merge(array_format: :serialized)
        super
      end

      define_entity :wire, :create_variable, :variable, -> { component }

      undef_method :interface
      undef_method :interface_port
      undef_method :localparam
    end
  end
end
