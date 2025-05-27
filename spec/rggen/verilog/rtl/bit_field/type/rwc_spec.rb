
# frozen_string_literal: true

RSpec.describe 'bit_field/type/rwc' do
  include_context 'clean-up builder'
  include_context 'bit field verilog common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rw, :rwc])
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0; reference 'register_4.bit_field_0' }
      end

      register_file do
        name 'register_file_3'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rwc; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rwc; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rwc; initial_value 0 }
            bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rwc; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
            bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0 }
            bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rwc; initial_value 0; reference 'register_file_5.register_file_0.register_0.bit_field_0' }
          end
        end
      end

      register do
        name 'register_4'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_5'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
        end
      end
    end
  end

  it '出力ポート#value_outを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, width: 1
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, width: 2
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_4', direction: :output, width: 4, array_size: [2]
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, width: 1, array_size: [4]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_2', direction: :output, width: 2, array_size: [4]
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_4', direction: :output, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[14]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, width: 2, array_size: [2, 2]
    )
    expect(bit_fields[16]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_4', direction: :output, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[18]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_0', direction: :output, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[20]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_2', direction: :output, width: 2, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[22]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_4', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  context '参照ビットフィールドを持たない場合' do
    it '入力ポート#clearを持つ' do
      expect(bit_fields[0]).to have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_0_clear', direction: :input, width: 1
      )
      expect(bit_fields[2]).to have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_2_clear', direction: :input, width: 1
      )
      expect(bit_fields[4]).to have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_4_clear', direction: :input, width: 1, array_size: [2]
      )

      expect(bit_fields[6]).to have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_0_clear', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[8]).to have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_2_clear', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[10]).to have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_4_clear', direction: :input, width: 1, array_size: [4, 2]
      )

      expect(bit_fields[12]).to have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_0_clear', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[14]).to have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_2_clear', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[16]).to have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_4_clear', direction: :input, width: 1, array_size: [2, 2, 2]
      )

      expect(bit_fields[18]).to have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_0_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[20]).to have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_2_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[22]).to have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_4_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it '入力ポート#clearを持たない' do
      expect(bit_fields[1]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_1_clear', direction: :input, width: 1
      )
      expect(bit_fields[3]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_3_clear', direction: :input, width: 1
      )
      expect(bit_fields[5]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_0_bit_field_5_clear', direction: :input, width: 1, array_size: [2]
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_1_clear', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_3_clear', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[11]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_1_bit_field_5_clear', direction: :input, width: 1, array_size: [4, 2]
      )

      expect(bit_fields[13]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_1_clear', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[15]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_3_clear', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[17]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_2_bit_field_5_clear', direction: :input, width: 1, array_size: [2, 2, 2]
      )

      expect(bit_fields[19]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_1_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[21]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_3_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[23]).to not_have_port(
        :register_block, :clear,
        name: 'i_register_file_3_register_file_0_register_0_bit_field_5_clear', direction: :input, width: 1, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (1),
          .INITIAL_VALUE  (1'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[0+:1]),
          .i_sw_write_data    (w_bit_field_write_data[0+:1]),
          .o_sw_read_data     (w_bit_field_read_data[0+:1]),
          .o_sw_value         (w_bit_field_value[0+:1]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({1{1'b0}}),
          .i_hw_set           ({1{1'b0}}),
          .i_hw_clear         (i_register_0_bit_field_0_clear),
          .i_value            ({1{1'b0}}),
          .i_mask             ({1{1'b1}}),
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (1),
          .INITIAL_VALUE  (1'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[1+:1]),
          .i_sw_write_data    (w_bit_field_write_data[1+:1]),
          .o_sw_read_data     (w_bit_field_read_data[1+:1]),
          .o_sw_value         (w_bit_field_value[1+:1]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({1{1'b0}}),
          .i_hw_set           ({1{1'b0}}),
          .i_hw_clear         (w_register_value[800+:1]),
          .i_value            ({1{1'b0}}),
          .i_mask             ({1{1'b1}}),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (2),
          .INITIAL_VALUE  (2'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[4+:2]),
          .i_sw_write_data    (w_bit_field_write_data[4+:2]),
          .o_sw_read_data     (w_bit_field_read_data[4+:2]),
          .o_sw_value         (w_bit_field_value[4+:2]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({2{1'b0}}),
          .i_hw_set           ({2{1'b0}}),
          .i_hw_clear         (i_register_0_bit_field_2_clear),
          .i_value            ({2{1'b0}}),
          .i_mask             ({2{1'b1}}),
          .o_value            (o_register_0_bit_field_2),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (2),
          .INITIAL_VALUE  (2'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[6+:2]),
          .i_sw_write_data    (w_bit_field_write_data[6+:2]),
          .o_sw_read_data     (w_bit_field_read_data[6+:2]),
          .o_sw_value         (w_bit_field_value[6+:2]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({2{1'b0}}),
          .i_hw_set           ({2{1'b0}}),
          .i_hw_clear         (w_register_value[800+:1]),
          .i_value            ({2{1'b0}}),
          .i_mask             ({2{1'b1}}),
          .o_value            (o_register_0_bit_field_3),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[16+8*i+:4]),
          .i_sw_write_data    (w_bit_field_write_data[16+8*i+:4]),
          .o_sw_read_data     (w_bit_field_read_data[16+8*i+:4]),
          .o_sw_value         (w_bit_field_value[16+8*i+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (i_register_0_bit_field_4_clear[1*(i)+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_0_bit_field_4[4*(i)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[20+8*i+:4]),
          .i_sw_write_data    (w_bit_field_write_data[20+8*i+:4]),
          .o_sw_read_data     (w_bit_field_read_data[20+8*i+:4]),
          .o_sw_value         (w_bit_field_value[20+8*i+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (w_register_value[800+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_0_bit_field_5[4*(i)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[16+8*j+:4]),
          .i_sw_write_data    (w_bit_field_write_data[16+8*j+:4]),
          .o_sw_read_data     (w_bit_field_read_data[16+8*j+:4]),
          .o_sw_value         (w_bit_field_value[16+8*j+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (i_register_1_bit_field_4_clear[1*(2*i+j)+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_1_bit_field_4[4*(2*i+j)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[20+8*j+:4]),
          .i_sw_write_data    (w_bit_field_write_data[20+8*j+:4]),
          .o_sw_read_data     (w_bit_field_read_data[20+8*j+:4]),
          .o_sw_value         (w_bit_field_value[20+8*j+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (w_register_value[800+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_1_bit_field_5[4*(2*i+j)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[16]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[16+8*k+:4]),
          .i_sw_write_data    (w_bit_field_write_data[16+8*k+:4]),
          .o_sw_read_data     (w_bit_field_read_data[16+8*k+:4]),
          .o_sw_value         (w_bit_field_value[16+8*k+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (i_register_2_bit_field_4_clear[1*(4*i+2*j+k)+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_2_bit_field_4[4*(4*i+2*j+k)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[20+8*k+:4]),
          .i_sw_write_data    (w_bit_field_write_data[20+8*k+:4]),
          .o_sw_read_data     (w_bit_field_read_data[20+8*k+:4]),
          .o_sw_value         (w_bit_field_value[20+8*k+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (w_register_value[800+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_2_bit_field_5[4*(4*i+2*j+k)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[22]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[16+8*m+:4]),
          .i_sw_write_data    (w_bit_field_write_data[16+8*m+:4]),
          .o_sw_read_data     (w_bit_field_read_data[16+8*m+:4]),
          .o_sw_value         (w_bit_field_value[16+8*m+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (i_register_file_3_register_file_0_register_0_bit_field_4_clear[1*(16*i+8*j+4*k+2*l+m)+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_file_3_register_file_0_register_0_bit_field_4[4*(16*i+8*j+4*k+2*l+m)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[23]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0),
          .HW_ACCESS      (3'b100),
          .HW_CLEAR_WIDTH (1)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[20+8*m+:4]),
          .i_sw_write_data    (w_bit_field_write_data[20+8*m+:4]),
          .o_sw_read_data     (w_bit_field_read_data[20+8*m+:4]),
          .o_sw_value         (w_bit_field_value[20+8*m+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           ({4{1'b0}}),
          .i_hw_clear         (w_register_value[32*(26+2*i+j)+0+:1]),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_file_3_register_file_0_register_0_bit_field_5[4*(16*i+8*j+4*k+2*l+m)+:4]),
          .o_value_unmasked   ()
        );
      CODE
    end
  end
end
