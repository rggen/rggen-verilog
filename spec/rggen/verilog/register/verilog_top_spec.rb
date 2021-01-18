# frozen_string_literal: true

RSpec.describe 'register/verilog_top' do
  include_context 'verilog common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_registers(&body)
    create_verilog(&body).registers
  end

  context 'レジスタがビットフィールドを持つ場合' do
    def check_bit_field_signals(register, width)
      expect(register).to have_wire(
        :bit_field_valid,
        name: 'w_bit_field_valid', width: 1
      )
      expect(register).to have_wire(
        :bit_field_read_mask,
        name: 'w_bit_field_read_mask', width: width
      )
      expect(register).to have_wire(
        :bit_field_write_mask,
        name: 'w_bit_field_write_mask', width: width
      )
      expect(register).to have_wire(
        :bit_field_write_data,
        name: 'w_bit_field_write_data', width: width
      )
      expect(register).to have_wire(
        :bit_field_read_data,
        name: 'w_bit_field_read_data', width: width
      )
      expect(register).to have_wire(
        :bit_field_value,
        name: 'w_bit_field_value', width: width
      )
    end

    it 'ビットフィールドアクセス用の信号群を持つ' do
      registers = create_registers do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
      end

      check_bit_field_signals(registers[0], 32)
      check_bit_field_signals(registers[1], 64)
      check_bit_field_signals(registers[2], 32)
      check_bit_field_signals(registers[3], 64)
      check_bit_field_signals(registers[4], 32)
      check_bit_field_signals(registers[5], 64)
    end
  end

  context 'レジスタがビットフィールドを持たない場合' do
    it 'ビットフィールドアクセス用の信号群を持たない' do
      registers = create_registers do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [64]
          type :external
        end
      end

      expect(registers[0]).to not_have_wire(
        :bit_field_valid,
        name: 'w_bit_field_valid', width: 1
      )
      expect(registers[0]).to not_have_wire(
        :bit_field_read_mask,
        name: 'w_bit_field_read_mask', width: 32
      )
      expect(registers[0]).to not_have_wire(
        :bit_field_write_mask,
        name: 'w_bit_field_write_mask', width: 32
      )
      expect(registers[0]).to not_have_wire(
        :bit_field_write_data,
        name: 'w_bit_field_write_data', width: 32
      )
      expect(registers[0]).to not_have_wire(
        :bit_field_read_data,
        name: 'w_bit_field_read_data', width: 32
      )
      expect(registers[0]).to not_have_wire(
        :bit_field_value,
        name: 'w_bit_field_value', width: 32
      )
    end
  end

  describe '#generate_code' do
    it 'レジスタ階層のコードを出力する' do
      registers = create_registers do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          type :external
          size [4]
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          type [:indirect, 'register_0.bit_field_0', 'register_0.bit_field_1']
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          offset_address 0x50
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(registers[0]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_0
          wire w_bit_field_valid;
          wire [31:0] w_bit_field_read_mask;
          wire [31:0] w_bit_field_write_mask;
          wire [31:0] w_bit_field_write_data;
          wire [31:0] w_bit_field_read_data;
          wire [31:0] w_bit_field_value;
          rggen_default_register #(
            .READABLE       (1),
            .WRITABLE       (1),
            .ADDRESS_WIDTH  (8),
            .OFFSET_ADDRESS (8'h00),
            .BUS_WIDTH      (32),
            .DATA_WIDTH     (32),
            .VALID_BITS     (32'h00000303),
            .REGISTER_INDEX (0)
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
            .o_bit_field_valid      (w_bit_field_valid),
            .o_bit_field_read_mask  (w_bit_field_read_mask),
            .o_bit_field_write_mask (w_bit_field_write_mask),
            .o_bit_field_write_data (w_bit_field_write_data),
            .i_bit_field_read_data  (w_bit_field_read_data),
            .i_bit_field_value      (w_bit_field_value)
          );
          if (1) begin : g_bit_field_0
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
              .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_valid         (w_bit_field_valid),
              .i_sw_read_mask     (w_bit_field_read_mask[0+:2]),
              .i_sw_write_enable  (1'b1),
              .i_sw_write_mask    (w_bit_field_write_mask[0+:2]),
              .i_sw_write_data    (w_bit_field_write_data[0+:2]),
              .o_sw_read_data     (w_bit_field_read_data[0+:2]),
              .o_sw_value         (w_bit_field_value[0+:2]),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_0_bit_field_0),
              .o_value_unmasked   ()
            );
          end
          if (1) begin : g_bit_field_1
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
              .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_valid         (w_bit_field_valid),
              .i_sw_read_mask     (w_bit_field_read_mask[8+:2]),
              .i_sw_write_enable  (1'b1),
              .i_sw_write_mask    (w_bit_field_write_mask[8+:2]),
              .i_sw_write_data    (w_bit_field_write_data[8+:2]),
              .o_sw_read_data     (w_bit_field_read_data[8+:2]),
              .o_sw_value         (w_bit_field_value[8+:2]),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_0_bit_field_1),
              .o_value_unmasked   ()
            );
          end
        end endgenerate
      CODE

      expect(registers[1]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_1
          rggen_external_register #(
            .ADDRESS_WIDTH  (8),
            .BUS_WIDTH      (32),
            .START_ADDRESS  (8'h10),
            .END_ADDRESS    (8'h1f)
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
        end endgenerate
      CODE

      expect(registers[2]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_2
          genvar i;
          for (i = 0;i < 4;i = i + 1) begin : g
            wire w_bit_field_valid;
            wire [31:0] w_bit_field_read_mask;
            wire [31:0] w_bit_field_write_mask;
            wire [31:0] w_bit_field_write_data;
            wire [31:0] w_bit_field_read_data;
            wire [31:0] w_bit_field_value;
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (8),
              .OFFSET_ADDRESS (8'h20),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32),
              .VALID_BITS     (32'h00000303),
              .REGISTER_INDEX (i)
            ) u_register (
              .i_clk                  (i_clk),
              .i_rst_n                (i_rst_n),
              .i_register_valid       (w_register_valid),
              .i_register_access      (w_register_access),
              .i_register_address     (w_register_address),
              .i_register_write_data  (w_register_write_data),
              .i_register_strobe      (w_register_strobe),
              .o_register_active      (w_register_active[1*(2+i)+:1]),
              .o_register_ready       (w_register_ready[1*(2+i)+:1]),
              .o_register_status      (w_register_status[2*(2+i)+:2]),
              .o_register_read_data   (w_register_read_data[32*(2+i)+:32]),
              .o_register_value       (w_register_value[32*(2+i)+0+:32]),
              .o_bit_field_valid      (w_bit_field_valid),
              .o_bit_field_read_mask  (w_bit_field_read_mask),
              .o_bit_field_write_mask (w_bit_field_write_mask),
              .o_bit_field_write_data (w_bit_field_write_data),
              .i_bit_field_read_data  (w_bit_field_read_data),
              .i_bit_field_value      (w_bit_field_value)
            );
            if (1) begin : g_bit_field_0
              rggen_bit_field #(
                .WIDTH          (2),
                .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
                .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
                .SW_WRITE_ONCE  (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .i_sw_valid         (w_bit_field_valid),
                .i_sw_read_mask     (w_bit_field_read_mask[0+:2]),
                .i_sw_write_enable  (1'b1),
                .i_sw_write_mask    (w_bit_field_write_mask[0+:2]),
                .i_sw_write_data    (w_bit_field_write_data[0+:2]),
                .o_sw_read_data     (w_bit_field_read_data[0+:2]),
                .o_sw_value         (w_bit_field_value[0+:2]),
                .i_hw_write_enable  (1'b0),
                .i_hw_write_data    ({2{1'b0}}),
                .i_hw_set           ({2{1'b0}}),
                .i_hw_clear         ({2{1'b0}}),
                .i_value            ({2{1'b0}}),
                .i_mask             ({2{1'b1}}),
                .o_value            (o_register_2_bit_field_0[2*(i)+:2]),
                .o_value_unmasked   ()
              );
            end
            if (1) begin : g_bit_field_1
              rggen_bit_field #(
                .WIDTH          (2),
                .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
                .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
                .SW_WRITE_ONCE  (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .i_sw_valid         (w_bit_field_valid),
                .i_sw_read_mask     (w_bit_field_read_mask[8+:2]),
                .i_sw_write_enable  (1'b1),
                .i_sw_write_mask    (w_bit_field_write_mask[8+:2]),
                .i_sw_write_data    (w_bit_field_write_data[8+:2]),
                .o_sw_read_data     (w_bit_field_read_data[8+:2]),
                .o_sw_value         (w_bit_field_value[8+:2]),
                .i_hw_write_enable  (1'b0),
                .i_hw_write_data    ({2{1'b0}}),
                .i_hw_set           ({2{1'b0}}),
                .i_hw_clear         ({2{1'b0}}),
                .i_value            ({2{1'b0}}),
                .i_mask             ({2{1'b1}}),
                .o_value            (o_register_2_bit_field_1[2*(i)+:2]),
                .o_value_unmasked   ()
              );
            end
          end
        end endgenerate
      CODE

      expect(registers[3]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_3
          genvar i;
          genvar j;
          for (i = 0;i < 2;i = i + 1) begin : g
            for (j = 0;j < 2;j = j + 1) begin : g
              wire [3:0] w_indirect_index;
              wire w_bit_field_valid;
              wire [31:0] w_bit_field_read_mask;
              wire [31:0] w_bit_field_write_mask;
              wire [31:0] w_bit_field_write_data;
              wire [31:0] w_bit_field_read_data;
              wire [31:0] w_bit_field_value;
              assign w_indirect_index = {w_register_value[0+:2], w_register_value[8+:2]};
              rggen_indirect_register #(
                .READABLE             (1),
                .WRITABLE             (1),
                .ADDRESS_WIDTH        (8),
                .OFFSET_ADDRESS       (8'h30),
                .BUS_WIDTH            (32),
                .DATA_WIDTH           (32),
                .VALID_BITS           (32'h00000303),
                .INDIRECT_INDEX_WIDTH (4),
                .INDIRECT_INDEX_VALUE ({i[0+:2], j[0+:2]})
              ) u_register (
                .i_clk                  (i_clk),
                .i_rst_n                (i_rst_n),
                .i_register_valid       (w_register_valid),
                .i_register_access      (w_register_access),
                .i_register_address     (w_register_address),
                .i_register_write_data  (w_register_write_data),
                .i_register_strobe      (w_register_strobe),
                .o_register_active      (w_register_active[1*(6+2*i+j)+:1]),
                .o_register_ready       (w_register_ready[1*(6+2*i+j)+:1]),
                .o_register_status      (w_register_status[2*(6+2*i+j)+:2]),
                .o_register_read_data   (w_register_read_data[32*(6+2*i+j)+:32]),
                .o_register_value       (w_register_value[32*(6+2*i+j)+0+:32]),
                .i_indirect_index       (w_indirect_index),
                .o_bit_field_valid      (w_bit_field_valid),
                .o_bit_field_read_mask  (w_bit_field_read_mask),
                .o_bit_field_write_mask (w_bit_field_write_mask),
                .o_bit_field_write_data (w_bit_field_write_data),
                .i_bit_field_read_data  (w_bit_field_read_data),
                .i_bit_field_value      (w_bit_field_value)
              );
              if (1) begin : g_bit_field_0
                rggen_bit_field #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
                  .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
                  .SW_WRITE_ONCE  (0)
                ) u_bit_field (
                  .i_clk              (i_clk),
                  .i_rst_n            (i_rst_n),
                  .i_sw_valid         (w_bit_field_valid),
                  .i_sw_read_mask     (w_bit_field_read_mask[0+:2]),
                  .i_sw_write_enable  (1'b1),
                  .i_sw_write_mask    (w_bit_field_write_mask[0+:2]),
                  .i_sw_write_data    (w_bit_field_write_data[0+:2]),
                  .o_sw_read_data     (w_bit_field_read_data[0+:2]),
                  .o_sw_value         (w_bit_field_value[0+:2]),
                  .i_hw_write_enable  (1'b0),
                  .i_hw_write_data    ({2{1'b0}}),
                  .i_hw_set           ({2{1'b0}}),
                  .i_hw_clear         ({2{1'b0}}),
                  .i_value            ({2{1'b0}}),
                  .i_mask             ({2{1'b1}}),
                  .o_value            (o_register_3_bit_field_0[2*(2*i+j)+:2]),
                  .o_value_unmasked   ()
                );
              end
              if (1) begin : g_bit_field_1
                rggen_bit_field #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
                  .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
                  .SW_WRITE_ONCE  (0)
                ) u_bit_field (
                  .i_clk              (i_clk),
                  .i_rst_n            (i_rst_n),
                  .i_sw_valid         (w_bit_field_valid),
                  .i_sw_read_mask     (w_bit_field_read_mask[8+:2]),
                  .i_sw_write_enable  (1'b1),
                  .i_sw_write_mask    (w_bit_field_write_mask[8+:2]),
                  .i_sw_write_data    (w_bit_field_write_data[8+:2]),
                  .o_sw_read_data     (w_bit_field_read_data[8+:2]),
                  .o_sw_value         (w_bit_field_value[8+:2]),
                  .i_hw_write_enable  (1'b0),
                  .i_hw_write_data    ({2{1'b0}}),
                  .i_hw_set           ({2{1'b0}}),
                  .i_hw_clear         ({2{1'b0}}),
                  .i_value            ({2{1'b0}}),
                  .i_mask             ({2{1'b1}}),
                  .o_value            (o_register_3_bit_field_1[2*(2*i+j)+:2]),
                  .o_value_unmasked   ()
                );
              end
            end
          end
        end endgenerate
      CODE

      expect(registers[4]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_4
          wire w_bit_field_valid;
          wire [31:0] w_bit_field_read_mask;
          wire [31:0] w_bit_field_write_mask;
          wire [31:0] w_bit_field_write_data;
          wire [31:0] w_bit_field_read_data;
          wire [31:0] w_bit_field_value;
          rggen_default_register #(
            .READABLE       (1),
            .WRITABLE       (1),
            .ADDRESS_WIDTH  (8),
            .OFFSET_ADDRESS (8'h40),
            .BUS_WIDTH      (32),
            .DATA_WIDTH     (32),
            .VALID_BITS     (32'h00000003),
            .REGISTER_INDEX (0)
          ) u_register (
            .i_clk                  (i_clk),
            .i_rst_n                (i_rst_n),
            .i_register_valid       (w_register_valid),
            .i_register_access      (w_register_access),
            .i_register_address     (w_register_address),
            .i_register_write_data  (w_register_write_data),
            .i_register_strobe      (w_register_strobe),
            .o_register_active      (w_register_active[10+:1]),
            .o_register_ready       (w_register_ready[10+:1]),
            .o_register_status      (w_register_status[20+:2]),
            .o_register_read_data   (w_register_read_data[320+:32]),
            .o_register_value       (w_register_value[320+:32]),
            .o_bit_field_valid      (w_bit_field_valid),
            .o_bit_field_read_mask  (w_bit_field_read_mask),
            .o_bit_field_write_mask (w_bit_field_write_mask),
            .o_bit_field_write_data (w_bit_field_write_data),
            .i_bit_field_read_data  (w_bit_field_read_data),
            .i_bit_field_value      (w_bit_field_value)
          );
          if (1) begin : g_register_4
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
              .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_valid         (w_bit_field_valid),
              .i_sw_read_mask     (w_bit_field_read_mask[0+:2]),
              .i_sw_write_enable  (1'b1),
              .i_sw_write_mask    (w_bit_field_write_mask[0+:2]),
              .i_sw_write_data    (w_bit_field_write_data[0+:2]),
              .o_sw_read_data     (w_bit_field_read_data[0+:2]),
              .o_sw_value         (w_bit_field_value[0+:2]),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_4),
              .o_value_unmasked   ()
            );
          end
        end endgenerate
      CODE

      expect(registers[5]).to generate_code(:register_file, :top_down, <<~'CODE')
        if (1) begin : g_register_0
          genvar k;
          genvar l;
          for (k = 0;k < 2;k = k + 1) begin : g
            for (l = 0;l < 2;l = l + 1) begin : g
              wire w_bit_field_valid;
              wire [31:0] w_bit_field_read_mask;
              wire [31:0] w_bit_field_write_mask;
              wire [31:0] w_bit_field_write_data;
              wire [31:0] w_bit_field_read_data;
              wire [31:0] w_bit_field_value;
              rggen_default_register #(
                .READABLE       (1),
                .WRITABLE       (1),
                .ADDRESS_WIDTH  (8),
                .OFFSET_ADDRESS (8'h50+16*(2*i+j)),
                .BUS_WIDTH      (32),
                .DATA_WIDTH     (32),
                .VALID_BITS     (32'h00000003),
                .REGISTER_INDEX (2*k+l)
              ) u_register (
                .i_clk                  (i_clk),
                .i_rst_n                (i_rst_n),
                .i_register_valid       (w_register_valid),
                .i_register_access      (w_register_access),
                .i_register_address     (w_register_address),
                .i_register_write_data  (w_register_write_data),
                .i_register_strobe      (w_register_strobe),
                .o_register_active      (w_register_active[1*(11+4*(2*i+j)+2*k+l)+:1]),
                .o_register_ready       (w_register_ready[1*(11+4*(2*i+j)+2*k+l)+:1]),
                .o_register_status      (w_register_status[2*(11+4*(2*i+j)+2*k+l)+:2]),
                .o_register_read_data   (w_register_read_data[32*(11+4*(2*i+j)+2*k+l)+:32]),
                .o_register_value       (w_register_value[32*(11+4*(2*i+j)+2*k+l)+0+:32]),
                .o_bit_field_valid      (w_bit_field_valid),
                .o_bit_field_read_mask  (w_bit_field_read_mask),
                .o_bit_field_write_mask (w_bit_field_write_mask),
                .o_bit_field_write_data (w_bit_field_write_data),
                .i_bit_field_read_data  (w_bit_field_read_data),
                .i_bit_field_value      (w_bit_field_value)
              );
              if (1) begin : g_bit_field_0
                rggen_bit_field #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (`rggen_slice(2'h0, 2, 0)),
                  .SW_READ_ACTION (`RGGEN_READ_DEFAULT),
                  .SW_WRITE_ONCE  (0)
                ) u_bit_field (
                  .i_clk              (i_clk),
                  .i_rst_n            (i_rst_n),
                  .i_sw_valid         (w_bit_field_valid),
                  .i_sw_read_mask     (w_bit_field_read_mask[0+:2]),
                  .i_sw_write_enable  (1'b1),
                  .i_sw_write_mask    (w_bit_field_write_mask[0+:2]),
                  .i_sw_write_data    (w_bit_field_write_data[0+:2]),
                  .o_sw_read_data     (w_bit_field_read_data[0+:2]),
                  .o_sw_value         (w_bit_field_value[0+:2]),
                  .i_hw_write_enable  (1'b0),
                  .i_hw_write_data    ({2{1'b0}}),
                  .i_hw_set           ({2{1'b0}}),
                  .i_hw_clear         ({2{1'b0}}),
                  .i_value            ({2{1'b0}}),
                  .i_mask             ({2{1'b1}}),
                  .o_value            (o_register_file_5_register_file_0_register_0_bit_field_0[2*(8*i+4*j+2*k+l)+:2]),
                  .o_value_unmasked   ()
                );
              end
            end
          end
        end
      CODE
    end
  end
end
