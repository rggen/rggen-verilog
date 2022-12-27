# frozen_string_literal: true

RSpec.describe 'register/type/external' do
  include_context 'clean-up builder'
  include_context 'verilog rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register, [:name, :type, :offset_address, :size])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:bit_field, :name)
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register, :verilog_top)
  end

  def create_registers(&body)
    create_verilog_rtl(&body).registers
  end

  it '外部アクセス用のポート群を持つ' do
    registers = create_registers do
      byte_size 256
      register { name 'register_0'; offset_address 0x00; type :external; size [1] }
    end

    expect(registers[0]).to have_port(
      :register_block, :external_valid,
      name: 'o_register_0_valid', direction: :output, width: 1
    )
    expect(registers[0]).to have_port(
      :register_block, :external_access,
      name: 'o_register_0_access', direction: :output, width: 2
    )
    expect(registers[0]).to have_port(
      :register_block, :external_address,
      name: 'o_register_0_address', direction: :output, width: 8
    )
    expect(registers[0]).to have_port(
      :register_block, :external_write_data,
      name: 'o_register_0_data', direction: :output, width: 32
    )
    expect(registers[0]).to have_port(
      :register_block, :external_strobe,
      name: 'o_register_0_strobe', direction: :output, width: 4
    )
    expect(registers[0]).to have_port(
      :register_block, :external_ready,
      name: 'i_register_0_ready', direction: :input, width: 1
    )
    expect(registers[0]).to have_port(
      :register_block, :external_status,
      name: 'i_register_0_status', direction: :input, width: 2
    )
    expect(registers[0]).to have_port(
      :register_block, :external_read_data,
      name: 'i_register_0_data', direction: :input, width: 32
    )
  end

  describe '#generate_code' do
    it 'rggen_exernal_registerをインスタンスするコードを出力する' do
      registers = create_registers do
        byte_size 256
        register { name 'register_0'; offset_address 0x00; type :external; size [1] }
        register { name 'register_1'; offset_address 0x80; type :external; size [32] }
      end

      expect(registers[0]).to generate_code(:register, :top_down, <<~'CODE')
        rggen_external_register #(
          .ADDRESS_WIDTH  (8),
          .BUS_WIDTH      (32),
          .START_ADDRESS  (8'h00),
          .END_ADDRESS    (8'h03)
        ) u_register (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_register_valid       (w_register_valid),
          .i_register_access      (w_register_access),
          .i_register_address     (w_register_address),
          .i_register_write_data  (w_register_write_data),
          .i_register_strobe      (w_register_strobe),
          .o_register_active      (w_register_active[0+:1]),
          .o_register_ready       (w_register_ready[0+:1]),
          .o_register_status      (w_register_status[0+:2]),
          .o_register_read_data   (w_register_read_data[0+:32]),
          .o_register_value       (w_register_value[0+:32]),
          .o_external_valid       (o_register_0_valid),
          .o_external_access      (o_register_0_access),
          .o_external_address     (o_register_0_address),
          .o_external_data        (o_register_0_data),
          .o_external_strobe      (o_register_0_strobe),
          .i_external_ready       (i_register_0_ready),
          .i_external_status      (i_register_0_status),
          .i_external_data        (i_register_0_data)
        );
      CODE

      expect(registers[1]).to generate_code(:register, :top_down, <<~'CODE')
        rggen_external_register #(
          .ADDRESS_WIDTH  (8),
          .BUS_WIDTH      (32),
          .START_ADDRESS  (8'h80),
          .END_ADDRESS    (8'hff)
        ) u_register (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_register_valid       (w_register_valid),
          .i_register_access      (w_register_access),
          .i_register_address     (w_register_address),
          .i_register_write_data  (w_register_write_data),
          .i_register_strobe      (w_register_strobe),
          .o_register_active      (w_register_active[1+:1]),
          .o_register_ready       (w_register_ready[1+:1]),
          .o_register_status      (w_register_status[2+:2]),
          .o_register_read_data   (w_register_read_data[32+:32]),
          .o_register_value       (w_register_value[32+:32]),
          .o_external_valid       (o_register_1_valid),
          .o_external_access      (o_register_1_access),
          .o_external_address     (o_register_1_address),
          .o_external_data        (o_register_1_data),
          .o_external_strobe      (o_register_1_strobe),
          .i_external_ready       (i_register_1_ready),
          .i_external_status      (i_register_1_status),
          .i_external_data        (i_register_1_data)
        );
      CODE
    end
  end
end
