# frozen_string_literal: true

require 'rggen/systemverilog/rtl'
require_relative 'verilog/version'
require_relative 'verilog/utility/local_scope'
require_relative 'verilog/utility'
require_relative 'verilog/rtl/component'
require_relative 'verilog/rtl/feature'
require_relative 'verilog/rtl_header/component'
require_relative 'verilog/rtl_header/feature'
require_relative 'verilog/register_map/keyword_checker'
require_relative 'verilog/factories'

RgGen.setup_plugin :'rggen-verilog' do |plugin|
  plugin.version RgGen::Verilog::VERSION

  plugin.register_component :verilog_rtl do
    component RgGen::Verilog::RTL::Component,
              RgGen::Verilog::ComponentFactory
    feature RgGen::Verilog::RTL::Feature,
            RgGen::Verilog::FeatureFactory
  end

  plugin.files [
    'verilog/rtl/register_block/verilog_top',
    'verilog/rtl/register_block/protocol',
    'verilog/rtl/register_block/protocol/apb',
    'verilog/rtl/register_block/protocol/axi4lite',
    'verilog/rtl/register_block/protocol/avalon',
    'verilog/rtl/register_block/protocol/wishbone',
    'verilog/rtl/register_block/protocol/native',
    'verilog/rtl/register_file/verilog_top',
    'verilog/rtl/register/verilog_top',
    'verilog/rtl/register/type',
    'verilog/rtl/register/type/external',
    'verilog/rtl/register/type/indirect',
    'verilog/rtl/register/type/rw',
    'verilog/rtl/bit_field/verilog_top',
    'verilog/rtl/bit_field/type',
    'verilog/rtl/bit_field/type/custom',
    'verilog/rtl/bit_field/type/rc_w0c_w1c_wc_woc',
    'verilog/rtl/bit_field/type/ro_rotrg',
    'verilog/rtl/bit_field/type/rof',
    'verilog/rtl/bit_field/type/rohw',
    'verilog/rtl/bit_field/type/row0trg_row1trg',
    'verilog/rtl/bit_field/type/rowo_rowotrg',
    'verilog/rtl/bit_field/type/rs_w0s_w1s_ws_wos',
    'verilog/rtl/bit_field/type/rw_rwtrg_w1',
    'verilog/rtl/bit_field/type/rwc',
    'verilog/rtl/bit_field/type/rwe_rwl',
    'verilog/rtl/bit_field/type/rwhw',
    'verilog/rtl/bit_field/type/rws',
    'verilog/rtl/bit_field/type/w0crs_w0src_w1crs_w1src_wcrs_wsrc',
    'verilog/rtl/bit_field/type/w0t_w1t',
    'verilog/rtl/bit_field/type/w0trg_w1trg',
    'verilog/rtl/bit_field/type/wo_wo1_wotrg',
    'verilog/rtl/bit_field/type/wrc_wrs'
  ]

  plugin.register_component :verilog_rtl_header do
    component RgGen::Verilog::RTLHeader::Component,
              RgGen::Verilog::ComponentFactory
    feature RgGen::Verilog::RTLHeader::Feature,
            RgGen::Verilog::FeatureFactory
  end

  plugin.files [
    'verilog/rtl_header/bit_field/verilog_rtl_header',
    'verilog/rtl_header/register/verilog_rtl_header',
    'verilog/rtl_header/register_block/verilog_rtl_header'
  ]

  plugin.files [
    'verilog/register_map/name'
  ]
end
