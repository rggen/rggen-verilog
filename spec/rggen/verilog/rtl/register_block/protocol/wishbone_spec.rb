# frozen_string_literal: true

RSpec.describe 'register_block/protocol/wishbone' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size])
    RgGen.enable(:register_block, :protocol, [:wishbone])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:verilog_top])
  end

  let(:address_width) { 16 }

  let(:bus_width) { 32 }

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
    configuration = create_configuration(
      address_width: address_width, bus_width: bus_width, protocol: :wishbone
    )
    create_verilog_rtl(configuration, &body).register_blocks.first
  end

  it 'パラメータ#use_stallを持つ' do
    expect(register_block).to have_parameter(
      :use_stall,
      name: 'USE_STALL', parameter_type: :parameter, default: 1
    )
  end

  it 'wishbone用のポート群を持つ' do
    expect(register_block).to have_port(
      :wb_cyc,
      name: 'i_wb_cyc', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :wb_stb,
      name: 'i_wb_stb', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :wb_stall,
      name: 'o_wb_stall', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :wb_adr,
      name: 'i_wb_adr', direction: :input, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :wb_we,
      name: 'i_wb_we', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :wb_dat_i,
      name: 'i_wb_dat', direction: :input, width: bus_width
    )
    expect(register_block).to have_port(
      :wb_sel,
      name: 'i_wb_sel', direction: :input, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :wb_ack,
      name: 'o_wb_ack', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :wb_err,
      name: 'o_wb_err', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :wb_rty,
      name: 'o_wb_rty', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :wb_dat_o,
      name: 'o_wb_dat', direction: :output, width: bus_width
    )
  end

  describe '#generate_code' do
    it 'rggen_wishbone_adapterをインスタンスするコードを生成する' do
      expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
        rggen_wishbone_adapter #(
          .ADDRESS_WIDTH        (ADDRESS_WIDTH),
          .LOCAL_ADDRESS_WIDTH  (8),
          .BUS_WIDTH            (32),
          .REGISTERS            (3),
          .PRE_DECODE           (PRE_DECODE),
          .BASE_ADDRESS         (BASE_ADDRESS),
          .BYTE_SIZE            (256),
          .ERROR_STATUS         (ERROR_STATUS),
          .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
          .INSERT_SLICER        (INSERT_SLICER),
          .USE_STALL            (USE_STALL)
        ) u_adapter (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_wb_cyc               (i_wb_cyc),
          .i_wb_stb               (i_wb_stb),
          .o_wb_stall             (o_wb_stall),
          .i_wb_adr               (i_wb_adr),
          .i_wb_we                (i_wb_we),
          .i_wb_dat               (i_wb_dat),
          .i_wb_sel               (i_wb_sel),
          .o_wb_ack               (o_wb_ack),
          .o_wb_err               (o_wb_err),
          .o_wb_rty               (o_wb_rty),
          .o_wb_dat               (o_wb_dat),
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
