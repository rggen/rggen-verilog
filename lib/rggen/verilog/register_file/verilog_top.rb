# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :verilog_top) do
  verilog do
    include RgGen::SystemVerilog::RTL::RegisterIndex
  end
end
