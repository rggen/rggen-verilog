# frozen_string_literal: true

require 'rggen/systemverilog/rtl'
require_relative 'verilog/version'
require_relative 'verilog/utility/local_scope'
require_relative 'verilog/utility'
require_relative 'verilog/component'
require_relative 'verilog/feature'
require_relative 'verilog/factories'

RgGen.setup_plugin :'rggen-verilog' do |plugin|
  plugin.version RgGen::Verilog::VERSION

  plugin.register_component :verilog do
    component RgGen::Verilog::Component,
              RgGen::Verilog::ComponentFactory
    feature RgGen::Verilog::Feature,
            RgGen::Verilog::FeatureFactory
  end

  plugin.files [
    'verilog/register_block/verilog_top',
    'verilog/register_block/protocol',
    'verilog/register_block/protocol/apb',
    'verilog/register_block/protocol/axi4lite',
    'verilog/register_block/protocol/wishbone',
    'verilog/register_file/verilog_top',
    'verilog/register/verilog_top',
    'verilog/register/type',
    'verilog/register/type/external',
    'verilog/register/type/indirect',
    'verilog/bit_field/verilog_top',
    'verilog/bit_field/type',
    'verilog/bit_field/type/custom',
    'verilog/bit_field/type/rc_w0c_w1c_wc_woc',
    'verilog/bit_field/type/ro_rotrg',
    'verilog/bit_field/type/rof',
    'verilog/bit_field/type/row0trg_row1trg',
    'verilog/bit_field/type/rowo_rowotrg',
    'verilog/bit_field/type/rs_w0s_w1s_ws_wos',
    'verilog/bit_field/type/rw_rwtrg_w1',
    'verilog/bit_field/type/rwc',
    'verilog/bit_field/type/rwe_rwl',
    'verilog/bit_field/type/rws',
    'verilog/bit_field/type/w0crs_w0src_w1crs_w1src_wcrs_wsrc',
    'verilog/bit_field/type/w0t_w1t',
    'verilog/bit_field/type/w0trg_w1trg',
    'verilog/bit_field/type/wo_wo1_wotrg',
    'verilog/bit_field/type/wrc_wrs'
  ]
end
