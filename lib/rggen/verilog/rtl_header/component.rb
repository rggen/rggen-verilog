# frozen_string_literal: true

module RgGen
  module Verilog
    module RTLHeader
      class Component < SystemVerilog::Common::Component
        def macro_definitions
          [*@children, *@features.values].flat_map(&:macro_definitions)
        end
      end
    end
  end
end
