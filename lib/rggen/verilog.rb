# frozen_string_literal: true

require 'rggen/systemverilog/rtl'
require_relative 'verilog/version'
require_relative 'verilog/component'
require_relative 'verilog/feature'
require_relative 'verilog/factories'

module RgGen
  module Verilog
    PLUGIN_NAME = :verilog

    FEATURES = [
      'verilog/register/verilog_top',
      'verilog/register_block/protocol',
      'verilog/register_block/protocol/apb',
      'verilog/register_block/protocol/axi4lite',
      'verilog/register_block/verilog_top'
    ].freeze

    def self.register_component(builder)
      builder.output_component_registry(:verilog) do
        register_component [
          :root, :register_block, :register_file, :register, :bit_field
        ] do |layer|
          component Component, ComponentFactory
          feature Feature, FeatureFactory if layer != :root
        end
      end
    end

    def self.load_features
      FEATURES.each { |feature| require_relative feature }
    end

    def self.default_setup(builder)
      register_component(builder)
      load_features
    end
  end
end
