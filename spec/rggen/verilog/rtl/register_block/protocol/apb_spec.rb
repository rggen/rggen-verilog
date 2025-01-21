# frozen_string_literal: true

RSpec.describe 'register_block/protocol/apb' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size, :bus_width])
    RgGen.enable(:register_block, :protocol, [:apb])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:verilog_top])
  end

  let(:address_width) { 16 }

  let(:bus_width) { 32 }

  def create_register_block(&body)
    configuration = create_configuration(
      address_width: address_width, bus_width: bus_width, protocol: :apb
    )
    create_verilog_rtl(configuration, &body).register_blocks.first
  end

  it 'APB用のポート群を持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_port(
      :psel,
      name: 'i_psel', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :penable,
      name: 'i_penable', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :paddr,
      name: 'i_paddr', direction: :input, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :pprot,
      name: 'i_pprot', direction: :input, width: 3
    )
    expect(register_block).to have_port(
      :pwrite,
      name: 'i_pwrite', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :pstrb,
      name: 'i_pstrb', direction: :input, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :pwdata,
      name: 'i_pwdata', direction: :input, width: bus_width
    )
    expect(register_block).to have_port(
      :pready,
      name: 'o_pready', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :prdata,
      name: 'o_prdata', direction: :output, width: bus_width
    )
    expect(register_block).to have_port(
      :pslverr,
      name: 'o_pslverr', direction: :output, width: 1
    )
  end

  describe '#generate_code' do
    it 'rggen_apb_adapterをインスタンスするコードを生成する' do
      register_block = create_register_block do
        name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end

      expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
        rggen_apb_adapter #(
          .ADDRESS_WIDTH        (ADDRESS_WIDTH),
          .LOCAL_ADDRESS_WIDTH  (8),
          .BUS_WIDTH            (32),
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
          .i_psel                 (i_psel),
          .i_penable              (i_penable),
          .i_paddr                (i_paddr),
          .i_pprot                (i_pprot),
          .i_pwrite               (i_pwrite),
          .i_pstrb                (i_pstrb),
          .i_pwdata               (i_pwdata),
          .o_pready               (o_pready),
          .o_prdata               (o_prdata),
          .o_pslverr              (o_pslverr),
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
