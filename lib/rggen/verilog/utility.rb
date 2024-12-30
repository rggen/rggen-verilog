# frozen_string_literal: true

module RgGen
  module Verilog
    module Utility
      private

      def local_scope(name, attributes = {}, &)
        LocalScope.new(attributes.merge(name:), &).to_code
      end

      def fill_0(width)
        "{#{width}{1'b0}}"
      end

      def fill_1(width)
        "{#{width}{1'b1}}"
      end

      def width_cast(expression, _width)
        expression
      end
    end
  end
end
