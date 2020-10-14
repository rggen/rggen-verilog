# frozen_string_literal: true

require 'rggen/verilog'
require 'rggen/systemverilog/rtl/setup'

RgGen.setup RgGen::Verilog do |builder|
  builder.enable :register_block, [:verilog_top]
  builder.enable :register_file, [:verilog_top]
  builder.enable :register, [:verilog_top]
  builder.enable :bit_field, [:verilog_top]
end
