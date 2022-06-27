# frozen_string_literal: true

RSpec.describe 'register_block/protocol/axi4lite' do
  include_context 'verilog common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :protocol, :byte_size])
    RgGen.enable(:register_block, :protocol, [:axi4lite])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:register_block, [:verilog_top])
  end

  let(:address_width) { 16 }

  let(:bus_width) { 32 }

  def create_register_block(&body)
    configuration = create_configuration(
      address_width: address_width, bus_width: bus_width, protocol: :axi4lite
    )
    create_verilog(configuration, &body).register_blocks.first
  end

  it 'パラメータID_WIDTH/WRITE_FIRSTを持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_parameter(
      :id_width,
      name: 'ID_WIDTH', parameter_type: :parameter, default: 0
    )
    expect(register_block).to have_parameter(
      :write_first,
      name: 'WRITE_FIRST', parameter_type: :parameter, default: 1
    )
  end

  it 'AXI4LITE用のポート群を持つ' do
    register_block = create_register_block do
      name 'block_0'
      byte_size 256
      register { name 'register_0'; offset_address 0x00; size [1]; type :external }
    end

    expect(register_block).to have_port(
      :awvalid,
      name: 'i_awvalid', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :awready,
      name: 'o_awready', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :awid,
      name: 'i_awid', direction: :input, width: '((ID_WIDTH == 0) ? 1 : ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :awaddr,
      name: 'i_awaddr', direction: :input, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :awprot,
      name: 'i_awprot', direction: :input, width: 3
    )
    expect(register_block).to have_port(
      :wvalid,
      name: 'i_wvalid', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :wready,
      name: 'o_wready', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :wdata,
      name: 'i_wdata', direction: :input, width: bus_width
    )
    expect(register_block).to have_port(
      :wstrb,
      name: 'i_wstrb', direction: :input, width: bus_width / 8
    )
    expect(register_block).to have_port(
      :bvalid,
      name: 'o_bvalid', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :bready,
      name: 'i_bready', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :bid,
      name: 'o_bid', direction: :output, width: '((ID_WIDTH == 0) ? 1 : ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :bresp,
      name: 'o_bresp', direction: :output, width: 2
    )
    expect(register_block).to have_port(
      :arvalid,
      name: 'i_arvalid', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :arready,
      name: 'o_arready', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :arid,
      name: 'i_arid', direction: :input, width: '((ID_WIDTH == 0) ? 1 : ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :araddr,
      name: 'i_araddr', direction: :input, width: 'ADDRESS_WIDTH'
    )
    expect(register_block).to have_port(
      :arprot,
      name: 'i_arprot', direction: :input, width: 3
    )
    expect(register_block).to have_port(
      :rvalid,
      name: 'o_rvalid', direction: :output, width: 1
    )
    expect(register_block).to have_port(
      :rready,
      name: 'i_rready', direction: :input, width: 1
    )
    expect(register_block).to have_port(
      :rid,
      name: 'o_rid', direction: :output, width: '((ID_WIDTH == 0) ? 1 : ID_WIDTH)'
    )
    expect(register_block).to have_port(
      :rdata,
      name: 'o_rdata', direction: :output, width: bus_width
    )
    expect(register_block).to have_port(
      :rresp,
      name: 'o_rresp', direction: :output, width: 2
    )
  end

  describe '#generate_code' do
    it 'rggen_axi4lite_adapterをインスタンスするコードを生成する' do
      register_block = create_register_block do
        name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end

      expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
        rggen_axi4lite_adapter #(
          .ID_WIDTH             (ID_WIDTH),
          .ADDRESS_WIDTH        (ADDRESS_WIDTH),
          .LOCAL_ADDRESS_WIDTH  (8),
          .BUS_WIDTH            (32),
          .REGISTERS            (3),
          .PRE_DECODE           (PRE_DECODE),
          .BASE_ADDRESS         (BASE_ADDRESS),
          .BYTE_SIZE            (256),
          .ERROR_STATUS         (ERROR_STATUS),
          .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
          .WRITE_FIRST          (WRITE_FIRST)
        ) u_adapter (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_awvalid              (i_awvalid),
          .o_awready              (o_awready),
          .i_awid                 (i_awid),
          .i_awaddr               (i_awaddr),
          .i_awprot               (i_awprot),
          .i_wvalid               (i_wvalid),
          .o_wready               (o_wready),
          .i_wdata                (i_wdata),
          .i_wstrb                (i_wstrb),
          .o_bvalid               (o_bvalid),
          .i_bready               (i_bready),
          .o_bid                  (o_bid),
          .o_bresp                (o_bresp),
          .i_arvalid              (i_arvalid),
          .o_arready              (o_arready),
          .i_arid                 (i_arid),
          .i_araddr               (i_araddr),
          .i_arprot               (i_arprot),
          .o_rvalid               (o_rvalid),
          .i_rready               (i_rready),
          .o_rid                  (o_rid),
          .o_rdata                (o_rdata),
          .o_rresp                (o_rresp),
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
