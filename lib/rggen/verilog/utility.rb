# frozen_string_literal: true

module RgGen
  module Verilog
    module Utility
      private

      def local_scope(name, attributes = {}, &block)
        LocalScope.new(attributes.merge(name: name), &block).to_code
      end
    end
  end
end
