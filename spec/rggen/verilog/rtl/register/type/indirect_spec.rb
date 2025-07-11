# frozen_string_literal: true

RSpec.describe 'register/type/indirect' do
  include_context 'clean-up builder'
  include_context 'verilog rtl common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:ro, :rw, :wo, :reserved])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  let(:registers) do
    verilog = create_verilog_rtl do
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x08
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_3'
        offset_address 0x0C
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
        end
      end

      register do
        name 'register_4'
        offset_address 0x10
        type [:indirect, ['register_0.bit_field_0', 1]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x14
        size [2]
        type [:indirect, 'register_0.bit_field_1']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x18
        size [2, 4]
        type [:indirect, 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x1c
        size [2, 4]
        type [:indirect, ['register_0.bit_field_0', 0], 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_8'
        offset_address 0x20
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_9'
        offset_address 0x24
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_10'
        offset_address 0x28
        size [2]
        type [:indirect, 'register_1', ['register_2', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_11'
        offset_address 0x2C
        size [2, 4]
        type [
          :indirect,
          ['register_file_3.register_0.bit_field_0', 0],
          'register_file_3.register_0.bit_field_1',
          'register_file_3.register_0.bit_field_2'
        ]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_12'
        offset_address 0x30
        size [2, 2]
        register_file do
          name 'register_file_0'
          offset_address 0x00

          register do
            name 'register_0'
            offset_address 0x00
            size [2, 4]
            type [
              :indirect,
              ['register_0.bit_field_0', 0],
              'register_0.bit_field_1',
              'register_0.bit_field_2'
            ]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_1'
            offset_address 0x04
            size [2, 4]
            type [
              :indirect,
              ['register_file_3.register_0.bit_field_0', 0],
              'register_file_3.register_0.bit_field_1',
              'register_file_3.register_0.bit_field_2'
            ]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end
    end
    verilog.registers
  end

  it '#indirect_matchを持つ' do
    expect(registers[4]).to have_wire(
      :indirect_match,
      name: 'w_indirect_match', width: 1
    )
    expect(registers[5]).to have_wire(
      :indirect_match,
      name: 'w_indirect_match', width: 1
    )
    expect(registers[6]).to have_wire(
      :indirect_match,
      name: 'w_indirect_match', width: 2
    )
    expect(registers[7]).to have_wire(
      :indirect_match,
      name: 'w_indirect_match', width: 3
    )
  end

  describe '#generate_code' do
    it 'rggen_indirect_registerをインスタンスするコードを出力する' do
      expect(registers[4]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match = w_register_value[0+:1] == 1'h1;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h10),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (1)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[4+:1]),
          .o_register_ready         (w_register_ready[4+:1]),
          .o_register_status        (w_register_status[8+:2]),
          .o_register_read_data     (w_register_read_data[128+:32]),
          .o_register_value         (w_register_value[128+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match = w_register_value[8+:2] == i[0+:2];
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h14),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (1)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(5+i)+:1]),
          .o_register_ready         (w_register_ready[1*(5+i)+:1]),
          .o_register_status        (w_register_status[2*(5+i)+:2]),
          .o_register_read_data     (w_register_read_data[32*(5+i)+:32]),
          .o_register_value         (w_register_value[32*(5+i)+0+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[8+:2] == i[0+:2];
        assign w_indirect_match[1] = w_register_value[16+:4] == j[0+:4];
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h18),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (2)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(7+4*i+j)+:1]),
          .o_register_ready         (w_register_ready[1*(7+4*i+j)+:1]),
          .o_register_status        (w_register_status[2*(7+4*i+j)+:2]),
          .o_register_read_data     (w_register_read_data[32*(7+4*i+j)+:32]),
          .o_register_value         (w_register_value[32*(7+4*i+j)+0+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[8+:2] == i[0+:2];
        assign w_indirect_match[1] = w_register_value[16+:4] == j[0+:4];
        assign w_indirect_match[2] = w_register_value[0+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h1c),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (3)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(15+4*i+j)+:1]),
          .o_register_ready         (w_register_ready[1*(15+4*i+j)+:1]),
          .o_register_status        (w_register_status[2*(15+4*i+j)+:2]),
          .o_register_read_data     (w_register_read_data[32*(15+4*i+j)+:32]),
          .o_register_value         (w_register_value[32*(15+4*i+j)+0+:32]),
          .i_indirect_match         (w_indirect_match),
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
        assign w_indirect_match = w_register_value[0+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (0),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h20),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (1)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[23+:1]),
          .o_register_ready         (w_register_ready[23+:1]),
          .o_register_status        (w_register_status[46+:2]),
          .o_register_read_data     (w_register_read_data[736+:32]),
          .o_register_value         (w_register_value[736+:32]),
          .i_indirect_match         (w_indirect_match),
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
        assign w_indirect_match = w_register_value[0+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (0),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h24),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (1)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[24+:1]),
          .o_register_ready         (w_register_ready[24+:1]),
          .o_register_status        (w_register_status[48+:2]),
          .o_register_read_data     (w_register_read_data[768+:32]),
          .o_register_value         (w_register_value[768+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[10]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[32+:2] == i[0+:2];
        assign w_indirect_match[1] = w_register_value[64+:2] == 2'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h28),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (2)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(25+i)+:1]),
          .o_register_ready         (w_register_ready[1*(25+i)+:1]),
          .o_register_status        (w_register_status[2*(25+i)+:2]),
          .o_register_read_data     (w_register_read_data[32*(25+i)+:32]),
          .o_register_value         (w_register_value[32*(25+i)+0+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[11]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[104+:2] == i[0+:2];
        assign w_indirect_match[1] = w_register_value[112+:4] == j[0+:4];
        assign w_indirect_match[2] = w_register_value[96+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h2c),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (3)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(27+4*i+j)+:1]),
          .o_register_ready         (w_register_ready[1*(27+4*i+j)+:1]),
          .o_register_status        (w_register_status[2*(27+4*i+j)+:2]),
          .o_register_read_data     (w_register_read_data[32*(27+4*i+j)+:32]),
          .o_register_value         (w_register_value[32*(27+4*i+j)+0+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[12]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[8+:2] == k[0+:2];
        assign w_indirect_match[1] = w_register_value[16+:4] == l[0+:4];
        assign w_indirect_match[2] = w_register_value[0+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h30+8*(2*i+j)),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (3)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(35+16*(2*i+j)+4*k+l)+:1]),
          .o_register_ready         (w_register_ready[1*(35+16*(2*i+j)+4*k+l)+:1]),
          .o_register_status        (w_register_status[2*(35+16*(2*i+j)+4*k+l)+:2]),
          .o_register_read_data     (w_register_read_data[32*(35+16*(2*i+j)+4*k+l)+:32]),
          .o_register_value         (w_register_value[32*(35+16*(2*i+j)+4*k+l)+0+:32]),
          .i_indirect_match         (w_indirect_match),
          .o_bit_field_read_valid   (w_bit_field_read_valid),
          .o_bit_field_write_valid  (w_bit_field_write_valid),
          .o_bit_field_mask         (w_bit_field_mask),
          .o_bit_field_write_data   (w_bit_field_write_data),
          .i_bit_field_read_data    (w_bit_field_read_data),
          .i_bit_field_value        (w_bit_field_value)
        );
      CODE

      expect(registers[13]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, w_bit_field_read_data, w_bit_field_value)
        assign w_indirect_match[0] = w_register_value[104+:2] == k[0+:2];
        assign w_indirect_match[1] = w_register_value[112+:4] == l[0+:4];
        assign w_indirect_match[2] = w_register_value[96+:1] == 1'h0;
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h30+8*(2*i+j)+8'h04),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .INDIRECT_MATCH_WIDTH (3)
        ) u_register (
          .i_clk                    (i_clk),
          .i_rst_n                  (i_rst_n),
          .i_register_valid         (w_register_valid),
          .i_register_access        (w_register_access),
          .i_register_address       (w_register_address),
          .i_register_write_data    (w_register_write_data),
          .i_register_strobe        (w_register_strobe),
          .o_register_active        (w_register_active[1*(35+16*(2*i+j)+8+4*k+l)+:1]),
          .o_register_ready         (w_register_ready[1*(35+16*(2*i+j)+8+4*k+l)+:1]),
          .o_register_status        (w_register_status[2*(35+16*(2*i+j)+8+4*k+l)+:2]),
          .o_register_read_data     (w_register_read_data[32*(35+16*(2*i+j)+8+4*k+l)+:32]),
          .o_register_value         (w_register_value[32*(35+16*(2*i+j)+8+4*k+l)+0+:32]),
          .i_indirect_match         (w_indirect_match),
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
