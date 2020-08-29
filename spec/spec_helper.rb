# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.default_setup(builder)

require 'rggen/systemverilog/rtl'
RgGen::SystemVerilog::RTL.default_setup(builder)

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/verilog'
