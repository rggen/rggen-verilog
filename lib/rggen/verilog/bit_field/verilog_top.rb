# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :verilog_top) do
  verilog do
    include RgGen::SystemVerilog::RTL::BitFieldIndex

    export :value

    def value(offsets = nil, width = nil)
      value_lsb = bit_field.lsb(offsets&.last || local_index)
      value_width = width || bit_field.width
      register_value(offsets&.slice(0..-2), value_lsb, value_width)
    end

    private

    def register_value(offsets, lsb, width)
      index = register.index(offsets || register.local_indices)
      register_block.register_value[[index], lsb, width]
    end
  end
end
