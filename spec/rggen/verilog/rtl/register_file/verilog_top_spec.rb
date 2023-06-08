# frozen_string_literal: true

RSpec.describe 'register_file/verilog_top' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
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

  def create_register_files(&body)
    create_verilog_rtl(&body).register_blocks[0].register_files(false)
  end

  describe '#generate_code' do
    it 'レジスタファイル階層のコードを出力する' do
      register_files = create_register_files do
        name 'block_0'
        byte_size 512

        register_file do
          name 'register_file_0'
          offset_address 0x00
          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          offset_address 0x10

          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_2'
          offset_address 0x20
          size [2, 2]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_3'
          offset_address 0xa0
          size [2, step: 64]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      expect(register_files[0]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_0
          if (1) begin : g_register_0
            wire w_bit_field_valid;
            wire [31:0] w_bit_field_read_mask;
            wire [31:0] w_bit_field_write_mask;
            wire [31:0] w_bit_field_write_data;
            wire [31:0] w_bit_field_read_data;
            wire [31:0] w_bit_field_value;
            `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h000),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32)
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
                .WIDTH          (1),
                .INITIAL_VALUE  (1'h0),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .i_sw_valid         (w_bit_field_valid),
                .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                .i_sw_write_enable  (1'b1),
                .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                .o_sw_value         (w_bit_field_value[0+:1]),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_hw_write_enable  (1'b0),
                .i_hw_write_data    ({1{1'b0}}),
                .i_hw_set           ({1{1'b0}}),
                .i_hw_clear         ({1{1'b0}}),
                .i_value            ({1{1'b0}}),
                .i_mask             ({1{1'b1}}),
                .o_value            (o_register_file_0_register_0_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
          if (1) begin : g_register_1
            wire w_bit_field_valid;
            wire [31:0] w_bit_field_read_mask;
            wire [31:0] w_bit_field_write_mask;
            wire [31:0] w_bit_field_write_data;
            wire [31:0] w_bit_field_read_data;
            wire [31:0] w_bit_field_value;
            `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h004),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32)
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
              .o_bit_field_valid      (w_bit_field_valid),
              .o_bit_field_read_mask  (w_bit_field_read_mask),
              .o_bit_field_write_mask (w_bit_field_write_mask),
              .o_bit_field_write_data (w_bit_field_write_data),
              .i_bit_field_read_data  (w_bit_field_read_data),
              .i_bit_field_value      (w_bit_field_value)
            );
            if (1) begin : g_bit_field_0
              rggen_bit_field #(
                .WIDTH          (1),
                .INITIAL_VALUE  (1'h0),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .i_sw_valid         (w_bit_field_valid),
                .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                .i_sw_write_enable  (1'b1),
                .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                .o_sw_value         (w_bit_field_value[0+:1]),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_hw_write_enable  (1'b0),
                .i_hw_write_data    ({1{1'b0}}),
                .i_hw_set           ({1{1'b0}}),
                .i_hw_clear         ({1{1'b0}}),
                .i_value            ({1{1'b0}}),
                .i_mask             ({1{1'b1}}),
                .o_value            (o_register_file_0_register_1_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
        end endgenerate
      CODE

      expect(register_files[1]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_1
          if (1) begin : g_register_file_0
            if (1) begin : g_register_0
              wire w_bit_field_valid;
              wire [31:0] w_bit_field_read_mask;
              wire [31:0] w_bit_field_write_mask;
              wire [31:0] w_bit_field_write_data;
              wire [31:0] w_bit_field_read_data;
              wire [31:0] w_bit_field_value;
              `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
              rggen_default_register #(
                .READABLE       (1),
                .WRITABLE       (1),
                .ADDRESS_WIDTH  (9),
                .OFFSET_ADDRESS (9'h010),
                .BUS_WIDTH      (32),
                .DATA_WIDTH     (32)
              ) u_register (
                .i_clk                  (i_clk),
                .i_rst_n                (i_rst_n),
                .i_register_valid       (w_register_valid),
                .i_register_access      (w_register_access),
                .i_register_address     (w_register_address),
                .i_register_write_data  (w_register_write_data),
                .i_register_strobe      (w_register_strobe),
                .o_register_active      (w_register_active[2+:1]),
                .o_register_ready       (w_register_ready[2+:1]),
                .o_register_status      (w_register_status[4+:2]),
                .o_register_read_data   (w_register_read_data[64+:32]),
                .o_register_value       (w_register_value[64+:32]),
                .o_bit_field_valid      (w_bit_field_valid),
                .o_bit_field_read_mask  (w_bit_field_read_mask),
                .o_bit_field_write_mask (w_bit_field_write_mask),
                .o_bit_field_write_data (w_bit_field_write_data),
                .i_bit_field_read_data  (w_bit_field_read_data),
                .i_bit_field_value      (w_bit_field_value)
              );
              if (1) begin : g_bit_field_0
                rggen_bit_field #(
                  .WIDTH          (1),
                  .INITIAL_VALUE  (1'h0),
                  .SW_WRITE_ONCE  (0),
                  .TRIGGER        (0)
                ) u_bit_field (
                  .i_clk              (i_clk),
                  .i_rst_n            (i_rst_n),
                  .i_sw_valid         (w_bit_field_valid),
                  .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                  .i_sw_write_enable  (1'b1),
                  .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                  .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                  .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                  .o_sw_value         (w_bit_field_value[0+:1]),
                  .o_write_trigger    (),
                  .o_read_trigger     (),
                  .i_hw_write_enable  (1'b0),
                  .i_hw_write_data    ({1{1'b0}}),
                  .i_hw_set           ({1{1'b0}}),
                  .i_hw_clear         ({1{1'b0}}),
                  .i_value            ({1{1'b0}}),
                  .i_mask             ({1{1'b1}}),
                  .o_value            (o_register_file_1_register_file_0_register_0_bit_field_0),
                  .o_value_unmasked   ()
                );
              end
            end
          end
          if (1) begin : g_register_1
            wire w_bit_field_valid;
            wire [31:0] w_bit_field_read_mask;
            wire [31:0] w_bit_field_write_mask;
            wire [31:0] w_bit_field_write_data;
            wire [31:0] w_bit_field_read_data;
            wire [31:0] w_bit_field_value;
            `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h014),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32)
            ) u_register (
              .i_clk                  (i_clk),
              .i_rst_n                (i_rst_n),
              .i_register_valid       (w_register_valid),
              .i_register_access      (w_register_access),
              .i_register_address     (w_register_address),
              .i_register_write_data  (w_register_write_data),
              .i_register_strobe      (w_register_strobe),
              .o_register_active      (w_register_active[3+:1]),
              .o_register_ready       (w_register_ready[3+:1]),
              .o_register_status      (w_register_status[6+:2]),
              .o_register_read_data   (w_register_read_data[96+:32]),
              .o_register_value       (w_register_value[96+:32]),
              .o_bit_field_valid      (w_bit_field_valid),
              .o_bit_field_read_mask  (w_bit_field_read_mask),
              .o_bit_field_write_mask (w_bit_field_write_mask),
              .o_bit_field_write_data (w_bit_field_write_data),
              .i_bit_field_read_data  (w_bit_field_read_data),
              .i_bit_field_value      (w_bit_field_value)
            );
            if (1) begin : g_bit_field_0
              rggen_bit_field #(
                .WIDTH          (1),
                .INITIAL_VALUE  (1'h0),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .i_sw_valid         (w_bit_field_valid),
                .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                .i_sw_write_enable  (1'b1),
                .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                .o_sw_value         (w_bit_field_value[0+:1]),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_hw_write_enable  (1'b0),
                .i_hw_write_data    ({1{1'b0}}),
                .i_hw_set           ({1{1'b0}}),
                .i_hw_clear         ({1{1'b0}}),
                .i_value            ({1{1'b0}}),
                .i_mask             ({1{1'b1}}),
                .o_value            (o_register_file_1_register_1_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
        end endgenerate
      CODE

      expect(register_files[2]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_2
          genvar i;
          genvar j;
          for (i = 0;i < 2;i = i + 1) begin : g
            for (j = 0;j < 2;j = j + 1) begin : g
              if (1) begin : g_register_file_0
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
                      `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
                      rggen_default_register #(
                        .READABLE       (1),
                        .WRITABLE       (1),
                        .ADDRESS_WIDTH  (9),
                        .OFFSET_ADDRESS (9'h020+32*(2*i+j)+4*(2*k+l)),
                        .BUS_WIDTH      (32),
                        .DATA_WIDTH     (32)
                      ) u_register (
                        .i_clk                  (i_clk),
                        .i_rst_n                (i_rst_n),
                        .i_register_valid       (w_register_valid),
                        .i_register_access      (w_register_access),
                        .i_register_address     (w_register_address),
                        .i_register_write_data  (w_register_write_data),
                        .i_register_strobe      (w_register_strobe),
                        .o_register_active      (w_register_active[1*(4+8*(2*i+j)+2*k+l)+:1]),
                        .o_register_ready       (w_register_ready[1*(4+8*(2*i+j)+2*k+l)+:1]),
                        .o_register_status      (w_register_status[2*(4+8*(2*i+j)+2*k+l)+:2]),
                        .o_register_read_data   (w_register_read_data[32*(4+8*(2*i+j)+2*k+l)+:32]),
                        .o_register_value       (w_register_value[32*(4+8*(2*i+j)+2*k+l)+0+:32]),
                        .o_bit_field_valid      (w_bit_field_valid),
                        .o_bit_field_read_mask  (w_bit_field_read_mask),
                        .o_bit_field_write_mask (w_bit_field_write_mask),
                        .o_bit_field_write_data (w_bit_field_write_data),
                        .i_bit_field_read_data  (w_bit_field_read_data),
                        .i_bit_field_value      (w_bit_field_value)
                      );
                      if (1) begin : g_bit_field_0
                        rggen_bit_field #(
                          .WIDTH          (1),
                          .INITIAL_VALUE  (1'h0),
                          .SW_WRITE_ONCE  (0),
                          .TRIGGER        (0)
                        ) u_bit_field (
                          .i_clk              (i_clk),
                          .i_rst_n            (i_rst_n),
                          .i_sw_valid         (w_bit_field_valid),
                          .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                          .i_sw_write_enable  (1'b1),
                          .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                          .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                          .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                          .o_sw_value         (w_bit_field_value[0+:1]),
                          .o_write_trigger    (),
                          .o_read_trigger     (),
                          .i_hw_write_enable  (1'b0),
                          .i_hw_write_data    ({1{1'b0}}),
                          .i_hw_set           ({1{1'b0}}),
                          .i_hw_clear         ({1{1'b0}}),
                          .i_value            ({1{1'b0}}),
                          .i_mask             ({1{1'b1}}),
                          .o_value            (o_register_file_2_register_file_0_register_0_bit_field_0[1*(8*i+4*j+2*k+l)+:1]),
                          .o_value_unmasked   ()
                        );
                      end
                    end
                  end
                end
              end
              if (1) begin : g_register_1
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
                    `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
                    rggen_default_register #(
                      .READABLE       (1),
                      .WRITABLE       (1),
                      .ADDRESS_WIDTH  (9),
                      .OFFSET_ADDRESS (9'h020+32*(2*i+j)+9'h010+4*(2*k+l)),
                      .BUS_WIDTH      (32),
                      .DATA_WIDTH     (32)
                    ) u_register (
                      .i_clk                  (i_clk),
                      .i_rst_n                (i_rst_n),
                      .i_register_valid       (w_register_valid),
                      .i_register_access      (w_register_access),
                      .i_register_address     (w_register_address),
                      .i_register_write_data  (w_register_write_data),
                      .i_register_strobe      (w_register_strobe),
                      .o_register_active      (w_register_active[1*(4+8*(2*i+j)+4+2*k+l)+:1]),
                      .o_register_ready       (w_register_ready[1*(4+8*(2*i+j)+4+2*k+l)+:1]),
                      .o_register_status      (w_register_status[2*(4+8*(2*i+j)+4+2*k+l)+:2]),
                      .o_register_read_data   (w_register_read_data[32*(4+8*(2*i+j)+4+2*k+l)+:32]),
                      .o_register_value       (w_register_value[32*(4+8*(2*i+j)+4+2*k+l)+0+:32]),
                      .o_bit_field_valid      (w_bit_field_valid),
                      .o_bit_field_read_mask  (w_bit_field_read_mask),
                      .o_bit_field_write_mask (w_bit_field_write_mask),
                      .o_bit_field_write_data (w_bit_field_write_data),
                      .i_bit_field_read_data  (w_bit_field_read_data),
                      .i_bit_field_value      (w_bit_field_value)
                    );
                    if (1) begin : g_bit_field_0
                      rggen_bit_field #(
                        .WIDTH          (1),
                        .INITIAL_VALUE  (1'h0),
                        .SW_WRITE_ONCE  (0),
                        .TRIGGER        (0)
                      ) u_bit_field (
                        .i_clk              (i_clk),
                        .i_rst_n            (i_rst_n),
                        .i_sw_valid         (w_bit_field_valid),
                        .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                        .i_sw_write_enable  (1'b1),
                        .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                        .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                        .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                        .o_sw_value         (w_bit_field_value[0+:1]),
                        .o_write_trigger    (),
                        .o_read_trigger     (),
                        .i_hw_write_enable  (1'b0),
                        .i_hw_write_data    ({1{1'b0}}),
                        .i_hw_set           ({1{1'b0}}),
                        .i_hw_clear         ({1{1'b0}}),
                        .i_value            ({1{1'b0}}),
                        .i_mask             ({1{1'b1}}),
                        .o_value            (o_register_file_2_register_1_bit_field_0[1*(8*i+4*j+2*k+l)+:1]),
                        .o_value_unmasked   ()
                      );
                    end
                  end
                end
              end
            end
          end
        end endgenerate
      CODE

      expect(register_files[3]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_3
          genvar i;
          for (i = 0;i < 2;i = i + 1) begin : g
            if (1) begin : g_register_file_0
              if (1) begin : g_register_0
                genvar j;
                genvar k;
                for (j = 0;j < 2;j = j + 1) begin : g
                  for (k = 0;k < 2;k = k + 1) begin : g
                    wire w_bit_field_valid;
                    wire [31:0] w_bit_field_read_mask;
                    wire [31:0] w_bit_field_write_mask;
                    wire [31:0] w_bit_field_write_data;
                    wire [31:0] w_bit_field_read_data;
                    wire [31:0] w_bit_field_value;
                    `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
                    rggen_default_register #(
                      .READABLE       (1),
                      .WRITABLE       (1),
                      .ADDRESS_WIDTH  (9),
                      .OFFSET_ADDRESS (9'h0a0+64*i+4*(2*j+k)),
                      .BUS_WIDTH      (32),
                      .DATA_WIDTH     (32)
                    ) u_register (
                      .i_clk                  (i_clk),
                      .i_rst_n                (i_rst_n),
                      .i_register_valid       (w_register_valid),
                      .i_register_access      (w_register_access),
                      .i_register_address     (w_register_address),
                      .i_register_write_data  (w_register_write_data),
                      .i_register_strobe      (w_register_strobe),
                      .o_register_active      (w_register_active[1*(36+8*i+2*j+k)+:1]),
                      .o_register_ready       (w_register_ready[1*(36+8*i+2*j+k)+:1]),
                      .o_register_status      (w_register_status[2*(36+8*i+2*j+k)+:2]),
                      .o_register_read_data   (w_register_read_data[32*(36+8*i+2*j+k)+:32]),
                      .o_register_value       (w_register_value[32*(36+8*i+2*j+k)+0+:32]),
                      .o_bit_field_valid      (w_bit_field_valid),
                      .o_bit_field_read_mask  (w_bit_field_read_mask),
                      .o_bit_field_write_mask (w_bit_field_write_mask),
                      .o_bit_field_write_data (w_bit_field_write_data),
                      .i_bit_field_read_data  (w_bit_field_read_data),
                      .i_bit_field_value      (w_bit_field_value)
                    );
                    if (1) begin : g_bit_field_0
                      rggen_bit_field #(
                        .WIDTH          (1),
                        .INITIAL_VALUE  (1'h0),
                        .SW_WRITE_ONCE  (0),
                        .TRIGGER        (0)
                      ) u_bit_field (
                        .i_clk              (i_clk),
                        .i_rst_n            (i_rst_n),
                        .i_sw_valid         (w_bit_field_valid),
                        .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                        .i_sw_write_enable  (1'b1),
                        .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                        .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                        .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                        .o_sw_value         (w_bit_field_value[0+:1]),
                        .o_write_trigger    (),
                        .o_read_trigger     (),
                        .i_hw_write_enable  (1'b0),
                        .i_hw_write_data    ({1{1'b0}}),
                        .i_hw_set           ({1{1'b0}}),
                        .i_hw_clear         ({1{1'b0}}),
                        .i_value            ({1{1'b0}}),
                        .i_mask             ({1{1'b1}}),
                        .o_value            (o_register_file_3_register_file_0_register_0_bit_field_0[1*(4*i+2*j+k)+:1]),
                        .o_value_unmasked   ()
                      );
                    end
                  end
                end
              end
            end
            if (1) begin : g_register_1
              genvar j;
              genvar k;
              for (j = 0;j < 2;j = j + 1) begin : g
                for (k = 0;k < 2;k = k + 1) begin : g
                  wire w_bit_field_valid;
                  wire [31:0] w_bit_field_read_mask;
                  wire [31:0] w_bit_field_write_mask;
                  wire [31:0] w_bit_field_write_data;
                  wire [31:0] w_bit_field_read_data;
                  wire [31:0] w_bit_field_value;
                  `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
                  rggen_default_register #(
                    .READABLE       (1),
                    .WRITABLE       (1),
                    .ADDRESS_WIDTH  (9),
                    .OFFSET_ADDRESS (9'h0a0+64*i+9'h010+4*(2*j+k)),
                    .BUS_WIDTH      (32),
                    .DATA_WIDTH     (32)
                  ) u_register (
                    .i_clk                  (i_clk),
                    .i_rst_n                (i_rst_n),
                    .i_register_valid       (w_register_valid),
                    .i_register_access      (w_register_access),
                    .i_register_address     (w_register_address),
                    .i_register_write_data  (w_register_write_data),
                    .i_register_strobe      (w_register_strobe),
                    .o_register_active      (w_register_active[1*(36+8*i+4+2*j+k)+:1]),
                    .o_register_ready       (w_register_ready[1*(36+8*i+4+2*j+k)+:1]),
                    .o_register_status      (w_register_status[2*(36+8*i+4+2*j+k)+:2]),
                    .o_register_read_data   (w_register_read_data[32*(36+8*i+4+2*j+k)+:32]),
                    .o_register_value       (w_register_value[32*(36+8*i+4+2*j+k)+0+:32]),
                    .o_bit_field_valid      (w_bit_field_valid),
                    .o_bit_field_read_mask  (w_bit_field_read_mask),
                    .o_bit_field_write_mask (w_bit_field_write_mask),
                    .o_bit_field_write_data (w_bit_field_write_data),
                    .i_bit_field_read_data  (w_bit_field_read_data),
                    .i_bit_field_value      (w_bit_field_value)
                  );
                  if (1) begin : g_bit_field_0
                    rggen_bit_field #(
                      .WIDTH          (1),
                      .INITIAL_VALUE  (1'h0),
                      .SW_WRITE_ONCE  (0),
                      .TRIGGER        (0)
                    ) u_bit_field (
                      .i_clk              (i_clk),
                      .i_rst_n            (i_rst_n),
                      .i_sw_valid         (w_bit_field_valid),
                      .i_sw_read_mask     (w_bit_field_read_mask[0+:1]),
                      .i_sw_write_enable  (1'b1),
                      .i_sw_write_mask    (w_bit_field_write_mask[0+:1]),
                      .i_sw_write_data    (w_bit_field_write_data[0+:1]),
                      .o_sw_read_data     (w_bit_field_read_data[0+:1]),
                      .o_sw_value         (w_bit_field_value[0+:1]),
                      .o_write_trigger    (),
                      .o_read_trigger     (),
                      .i_hw_write_enable  (1'b0),
                      .i_hw_write_data    ({1{1'b0}}),
                      .i_hw_set           ({1{1'b0}}),
                      .i_hw_clear         ({1{1'b0}}),
                      .i_value            ({1{1'b0}}),
                      .i_mask             ({1{1'b1}}),
                      .o_value            (o_register_file_3_register_1_bit_field_0[1*(4*i+2*j+k)+:1]),
                      .o_value_unmasked   ()
                    );
                  end
                end
              end
            end
          end
        end endgenerate
      CODE
    end
  end
end
