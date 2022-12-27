# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :verilog_rtl_header) do
  verilog_rtl_header do
    write_file '<%= register_block.name %>.vh' do |f|
      f.include_guard
      f.macro_definitions register_block.macro_definitions
    end
  end
end
