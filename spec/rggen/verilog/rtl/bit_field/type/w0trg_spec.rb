# frozen_string_literal: true

RSpec.describe 'bit_field/type/w0trg' do
  include_context 'clean-up builder'
  include_context 'bit field verilog common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:w0trg])
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register_file do
        name 'register_file_3'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
          end
        end
      end
    end
  end

  it '出力ポート#triggerを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_0_trigger', direction: :output, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_1_trigger', direction: :output, width: 4
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_2_trigger', direction: :output, width: 4, array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_0_trigger', direction: :output, width: 1, array_size: [4]
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_1_trigger', direction: :output, width: 4, array_size: [4]
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_2_trigger', direction: :output, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_0_trigger', direction: :output, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_1_trigger', direction: :output, width: 4, array_size: [2, 2]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_2_trigger', direction: :output, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_0_trigger', direction: :output, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_1_trigger', direction: :output, width: 4, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_2_trigger', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  describe '#generate_code' do
    it 'rggen_bit_field_w01trgをインスタンスするコードを生成する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (1)
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
          .i_value            ({1{1'b0}}),
          .o_trigger          (o_register_0_bit_field_0_trigger)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_read_valid    (w_bit_field_read_valid),
          .i_sw_write_valid   (w_bit_field_write_valid),
          .i_sw_write_enable  (1'b1),
          .i_sw_mask          (w_bit_field_mask[8+:4]),
          .i_sw_write_data    (w_bit_field_write_data[8+:4]),
          .o_sw_read_data     (w_bit_field_read_data[8+:4]),
          .o_sw_value         (w_bit_field_value[8+:4]),
          .i_value            ({4{1'b0}}),
          .o_trigger          (o_register_0_bit_field_1_trigger)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
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
          .i_value            ({4{1'b0}}),
          .o_trigger          (o_register_0_bit_field_2_trigger[4*(i)+:4])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
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
          .i_value            ({4{1'b0}}),
          .o_trigger          (o_register_1_bit_field_2_trigger[4*(2*i+j)+:4])
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
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
          .i_value            ({4{1'b0}}),
          .o_trigger          (o_register_2_bit_field_2_trigger[4*(4*i+2*j+k)+:4])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
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
          .i_value            ({4{1'b0}}),
          .o_trigger          (o_register_file_3_register_file_0_register_0_bit_field_2_trigger[4*(16*i+8*j+4*k+2*l+m)+:4])
        );
      CODE
    end
  end
end
