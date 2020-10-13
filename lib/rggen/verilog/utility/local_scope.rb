# frozen_string_literal: true

module RgGen
  module Verilog
    module Utility
      class LocalScope < SystemVerilog::Common::Utility::LocalScope
        private

        def generate_for(genvar, size)
          "for (#{genvar} = 0;#{genvar} < #{size};#{genvar} = #{genvar} + 1) begin : g"
        end
      end
    end
  end
end
