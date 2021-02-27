# frozen_string_literal: true

require 'rggen/systemverilog/rtl'
require_relative 'verilog/version'
require_relative 'verilog/utility/local_scope'
require_relative 'verilog/utility'
require_relative 'verilog/component'
require_relative 'verilog/feature'
require_relative 'verilog/factories'

module RgGen
  module Verilog
    extend Core::Plugin

    setup_plugin :'rggen-verilog' do |plugin|
      plugin.register_component :verilog do
        component Component, ComponentFactory
        feature Feature, FeatureFactory
      end

      plugin.files [
        'verilog/bit_field/type',
        'verilog/bit_field/type/rc_w0c_w1c_wc_woc',
        'verilog/bit_field/type/ro',
        'verilog/bit_field/type/rof',
        'verilog/bit_field/type/rs_w0s_w1s_ws_wos',
        'verilog/bit_field/type/rw_w1_wo_wo1',
        'verilog/bit_field/type/rwc',
        'verilog/bit_field/type/rwe_rwl',
        'verilog/bit_field/type/rws',
        'verilog/bit_field/type/w0crs_w0src_w1crs_w1src_wcrs_wsrc',
        'verilog/bit_field/type/w0t_w1t',
        'verilog/bit_field/type/w0trg_w1trg',
        'verilog/bit_field/type/wrc_wrs',
        'verilog/bit_field/verilog_top',
        'verilog/register/type',
        'verilog/register/type/external',
        'verilog/register/type/indirect',
        'verilog/register/verilog_top',
        'verilog/register_block/protocol',
        'verilog/register_block/protocol/apb',
        'verilog/register_block/protocol/axi4lite',
        'verilog/register_block/verilog_top',
        'verilog/register_file/verilog_top'
      ]
    end
  end
end
