# frozen_string_literal: true

module RgGen
  module Verilog
    module RTL
      class Feature < SystemVerilog::RTL::Feature
        include Utility

        private

        def create_variable(data_type, attributes, &)
          attributes = attributes.merge(array_format: :serialized)
          super
        end

        def create_port(direction, attributes, &)
          attributes =
            attributes
              .except(:data_type)
              .merge(direction:, array_format: :serialized)
          DataObject.new(:argument, attributes, &)
        end

        def create_parameter(parameter_type, attributes, &)
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
end
