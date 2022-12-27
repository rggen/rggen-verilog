# frozen_string_literal: true

RSpec.describe 'register_block/protocol' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.define_list_item_feature(:register_block, :protocol, :foo) do
      sv_rtl {}
    end
    RgGen.define_list_item_feature(:register_block, :protocol, :foo) do
      verilog_rtl {}
    end

    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, [:protocol, :byte_size])
    RgGen.enable(:register_block, :protocol, :foo)
  end

  let(:bus_width) { 32 }

  let(:address_width) { 32 }

  let(:local_address_width) { 8 }

  let(:verilog_rtl) do
    configuration = create_configuration(protocol: :foo, bus_width: bus_width, address_width: address_width)
    create_verilog_rtl(configuration) { byte_size 256 }.register_blocks.first
  end

  it 'パラメータADDRESS_WIDTH/PRE_DECODE/BASE_ADDRESS/ERROR_STATUS/DEFAULT_READ_DATAを持つ' do
    expect(verilog_rtl).to have_parameter(
      :address_width,
      name: 'ADDRESS_WIDTH', parameter_type: :parameter, default: local_address_width
    )
    expect(verilog_rtl).to have_parameter(
      :pre_decode,
      name: 'PRE_DECODE', parameter_type: :parameter, default: 0
    )
    expect(verilog_rtl).to have_parameter(
      :base_address,
      name: 'BASE_ADDRESS', parameter_type: :parameter, width: 'ADDRESS_WIDTH', default: 0
    )
    expect(verilog_rtl).to have_parameter(
      :error_status,
      name: 'ERROR_STATUS', parameter_type: :parameter, default: 0
    )
    expect(verilog_rtl).to have_parameter(
      :default_read_data,
      name: 'DEFAULT_READ_DATA', parameter_type: :parameter, width: bus_width, default: 0
    )
  end
end
