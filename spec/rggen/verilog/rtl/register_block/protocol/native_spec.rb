# frozen_string_literal: true

RSpec.describe 'register_block/protocol/native' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, [:native])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:verilog_top])
  end

  let(:address_width) do
    16
  end

  let(:bus_width) do
    32
  end

  let(:register_block) do
    create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
      register { name 'register_1'; offset_address 0x10; size [1]; type :external }
      register { name 'register_2'; offset_address 0x20; size [1]; type :external }
    end
  end

  def create_register_block(&body)
    configuration =
      create_configuration(
        address_width:, bus_width:, protocol: :native
      )
    create_verilog_rtl(configuration, &body).register_blocks.first
  end

  it 'パラメータSTROBE_WIDTHを持つ' do
    expect(register_block).to have_parameter(
      :strobe_width,
      name: 'STROBE_WIDTH', parameter_type: :parameter, default: bus_width / 8
    )
  end

  it 'rggen_bus_if用の信号群を持つ' do
    expect(register_block).to have_port(
      :valid,
      name: 'i_csrbus_valid', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :access,
      name: 'i_csrbus_access', direction: :input, width: 2
    )
    expect(register_block).to have_port(
      :address,
      name: 'i_csrbus_address', direction: :input, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :write_data,
      name: 'i_csrbus_write_data', direction: :input, width: bus_width
    )
    expect(register_block).to have_port(
      :strobe,
      name: 'i_csrbus_strobe', direction: :input, width: 'STROBE_WIDTH'
    )
    expect(register_block).to have_port(
      :ready,
      name: 'o_csrbus_ready', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :status,
      name: 'o_csrbus_status', direction: :output, width: 2
    )
    expect(register_block).to have_port(
      :read_data,
      name: 'o_csrbus_read_data', direction: :output, width: bus_width
    )
  end

  describe '#generate_code' do
    it 'rggen_native_adapterをインスタンスするコードを生成する' do
      expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
        rggen_native_adapter #(
          .ADDRESS_WIDTH        (ADDRESS_WIDTH),
          .LOCAL_ADDRESS_WIDTH  (8),
          .BUS_WIDTH            (32),
          .STROBE_WIDTH         (STROBE_WIDTH),
          .REGISTERS            (3),
          .PRE_DECODE           (PRE_DECODE),
          .BASE_ADDRESS         (BASE_ADDRESS),
          .BYTE_SIZE            (256),
          .ERROR_STATUS         (ERROR_STATUS),
          .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
          .INSERT_SLICER        (INSERT_SLICER)
        ) u_adapter (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_csrbus_valid         (i_csrbus_valid),
          .i_csrbus_access        (i_csrbus_access),
          .i_csrbus_address       (i_csrbus_address),
          .i_csrbus_write_data    (i_csrbus_write_data),
          .i_csrbus_strobe        (i_csrbus_strobe),
          .o_csrbus_ready         (o_csrbus_ready),
          .o_csrbus_status        (o_csrbus_status),
          .o_csrbus_read_data     (o_csrbus_read_data),
          .o_register_valid       (w_register_valid),
          .o_register_access      (w_register_access),
          .o_register_address     (w_register_address),
          .o_register_write_data  (w_register_write_data),
          .o_register_strobe      (w_register_strobe),
          .i_register_active      (w_register_active),
          .i_register_ready       (w_register_ready),
          .i_register_status      (w_register_status),
          .i_register_read_data   (w_register_read_data)
        );
      CODE
    end
  end
end
