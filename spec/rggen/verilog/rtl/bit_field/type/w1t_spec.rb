# frozen_string_literal: true

RSpec.describe 'bit_field/type/w1t' do
  include_context 'clean-up builder'
  include_context 'bit field verilog common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:w1t])
  end

  it '出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1t; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :w1t; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1t; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1t; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1t; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1t; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1t; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1t; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :output, width: 2
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, width: 4, array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, width: 1, array_size: [4]
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :output, width: 2, array_size: [4]
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :output, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :output, width: 2, array_size: [2, 2]
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :output, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :output, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :output, width: 2, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1t; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :w1t; initial_value 0xabcd }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :w1t; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1t; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1t; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1t; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1t; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (1'h0),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
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
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (16),
          .INITIAL_VALUE    (16'habcd),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[16+:16]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[16+:16]),
          .i_sw_write_data    (w_bit_field_write_data[16+:16]),
          .o_sw_read_data     (w_bit_field_read_data[16+:16]),
          .o_sw_value         (w_bit_field_value[16+:16]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({16{1'b0}}),
          .i_hw_set           ({16{1'b0}}),
          .i_hw_clear         ({16{1'b0}}),
          .i_value            ({16{1'b0}}),
          .i_mask             ({16{1'b1}}),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (64),
          .INITIAL_VALUE    (64'h0000000000000000),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[0+:64]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[0+:64]),
          .i_sw_write_data    (w_bit_field_write_data[0+:64]),
          .o_sw_read_data     (w_bit_field_read_data[0+:64]),
          .o_sw_value         (w_bit_field_value[0+:64]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({64{1'b0}}),
          .i_hw_set           ({64{1'b0}}),
          .i_hw_clear         ({64{1'b0}}),
          .i_value            ({64{1'b0}}),
          .i_mask             ({64{1'b1}}),
          .o_value            (o_register_1_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (4'h0),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[0+8*i+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[0+8*i+:4]),
          .i_sw_write_data    (w_bit_field_write_data[0+8*i+:4]),
          .o_sw_read_data     (w_bit_field_read_data[0+8*i+:4]),
          .o_sw_value         (w_bit_field_value[0+8*i+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_2_bit_field_0[4*(i)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (4'h0),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[0+8*j+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[0+8*j+:4]),
          .i_sw_write_data    (w_bit_field_write_data[0+8*j+:4]),
          .o_sw_read_data     (w_bit_field_read_data[0+8*j+:4]),
          .o_sw_value         (w_bit_field_value[0+8*j+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_3_bit_field_0[4*(4*i+j)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (4'h0),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[0+8*k+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[0+8*k+:4]),
          .i_sw_write_data    (w_bit_field_write_data[0+8*k+:4]),
          .o_sw_read_data     (w_bit_field_read_data[0+8*k+:4]),
          .o_sw_value         (w_bit_field_value[0+8*k+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_4_bit_field_0[4*(8*i+4*j+k)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (4'h0),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_1_TOGGLE)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[0+8*m+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[0+8*m+:4]),
          .i_sw_write_data    (w_bit_field_write_data[0+8*m+:4]),
          .o_sw_read_data     (w_bit_field_read_data[0+8*m+:4]),
          .o_sw_value         (w_bit_field_value[0+8*m+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_0[4*(32*i+16*j+8*k+4*l+m)+:4]),
          .o_value_unmasked   ()
        );
      CODE
    end
  end
end
