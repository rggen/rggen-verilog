# frozen_string_literal: true

RSpec.describe 'register/type/default' do
  include_context 'clean-up builder'
  include_context 'verilog rtl common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  describe '#generate_code' do
    let(:registers) do
      verilog = create_verilog_rtl do
        byte_size 512

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          size [2, step: 8]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_6'
          offset_address 0x60
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          offset_address 0x70
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 8, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_8'
          offset_address 0x80
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
        end

        register do
          name 'register_9'
          offset_address 0x90
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wo; initial_value 0 }
        end

        register_file do
          name 'register_file_10'
          offset_address 0xa0
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x10
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4; type :rw; initial_value 0 }
            end
          end
        end

        register_file do
          name 'register_file_11'
          offset_address 0x120
          size [2, step: 64]
          register_file do
            name 'register_file_0'
            offset_address 0x10
            register do
              name 'register_0'
              offset_address 0x00
              size [2, step: 8]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4; type :rw; initial_value 0 }
            end
          end
        end
      end
      verilog.registers
    end

    it 'rggen_default_registerをインスタンスするコードを出力する' do
      expect(registers[0]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h000),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[0+:1]),
          .o_register_ready         (w_register_ready[0+:1]),
          .o_register_status        (w_register_status[0+:2]),
          .o_register_read_data     (w_register_read_data[0+:32]),
          .o_register_value         (w_register_value[0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[1]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h010+4*i),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(1+i)+:1]),
          .o_register_ready         (w_register_ready[1*(1+i)+:1]),
          .o_register_status        (w_register_status[2*(1+i)+:2]),
          .o_register_read_data     (w_register_read_data[32*(1+i)+:32]),
          .o_register_value         (w_register_value[64*(1+i)+0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[2]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h020+4*(2*i+j)),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(5+2*i+j)+:1]),
          .o_register_ready         (w_register_ready[1*(5+2*i+j)+:1]),
          .o_register_status        (w_register_status[2*(5+2*i+j)+:2]),
          .o_register_read_data     (w_register_read_data[32*(5+2*i+j)+:32]),
          .o_register_value         (w_register_value[64*(5+2*i+j)+0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[3]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h030+8*i),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(9+i)+:1]),
          .o_register_ready         (w_register_ready[1*(9+i)+:1]),
          .o_register_status        (w_register_status[2*(9+i)+:2]),
          .o_register_read_data     (w_register_read_data[32*(9+i)+:32]),
          .o_register_value         (w_register_value[64*(9+i)+0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[4]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'hffffffff, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h040),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[11+:1]),
          .o_register_ready         (w_register_ready[11+:1]),
          .o_register_status        (w_register_status[22+:2]),
          .o_register_read_data     (w_register_read_data[352+:32]),
          .o_register_value         (w_register_value[704+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'hf0f0f0f0, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h050),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[12+:1]),
          .o_register_ready         (w_register_ready[12+:1]),
          .o_register_status        (w_register_status[24+:2]),
          .o_register_read_data     (w_register_read_data[384+:32]),
          .o_register_value         (w_register_value[768+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(64, 64'h0000000100000000, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h060),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (64)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[13+:1]),
          .o_register_ready         (w_register_ready[13+:1]),
          .o_register_status        (w_register_status[26+:2]),
          .o_register_read_data     (w_register_read_data[416+:32]),
          .o_register_value         (w_register_value[832+:64]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(64, 64'hf0f0f0f0f0f0f0f0, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h070),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (64)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[14+:1]),
          .o_register_ready         (w_register_ready[14+:1]),
          .o_register_status        (w_register_status[28+:2]),
          .o_register_read_data     (w_register_read_data[448+:32]),
          .o_register_value         (w_register_value[896+:64]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[8]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (0),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h080),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[15+:1]),
          .o_register_ready         (w_register_ready[15+:1]),
          .o_register_status        (w_register_status[30+:2]),
          .o_register_read_data     (w_register_read_data[480+:32]),
          .o_register_value         (w_register_value[960+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[9]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (0),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h090),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[16+:1]),
          .o_register_ready         (w_register_ready[16+:1]),
          .o_register_status        (w_register_status[32+:2]),
          .o_register_read_data     (w_register_read_data[512+:32]),
          .o_register_value         (w_register_value[1024+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[10]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h0000ffff, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h0a0+32*(2*i+j)+9'h010+4*(2*k+l)),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(17+4*(2*i+j)+2*k+l)+:1]),
          .o_register_ready         (w_register_ready[1*(17+4*(2*i+j)+2*k+l)+:1]),
          .o_register_status        (w_register_status[2*(17+4*(2*i+j)+2*k+l)+:2]),
          .o_register_read_data     (w_register_read_data[32*(17+4*(2*i+j)+2*k+l)+:32]),
          .o_register_value         (w_register_value[64*(17+4*(2*i+j)+2*k+l)+0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[11]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h0000ffff, w_bit_field_read_data, w_bit_field_value)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (9),
          .OFFSET_ADDRESS (9'h120+64*i+9'h010+8*j),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(33+2*i+j)+:1]),
          .o_register_ready         (w_register_ready[1*(33+2*i+j)+:1]),
          .o_register_status        (w_register_status[2*(33+2*i+j)+:2]),
          .o_register_read_data     (w_register_read_data[32*(33+2*i+j)+:32]),
          .o_register_value         (w_register_value[64*(33+2*i+j)+0+:32]),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE
    end
  end
end
