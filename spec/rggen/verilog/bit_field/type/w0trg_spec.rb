# frozen_string_literal: true

RSpec.describe 'bit_field/type/w0trg' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:w0trg])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  let(:bit_fields) do
    verilog = create_verilog do
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
    verilog.bit_fields
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
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:1]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:1]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:1]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:1]),
          .o_bit_field_value      (w_bit_field_value[0+:1]),
          .o_trigger              (o_register_0_bit_field_0_trigger)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[8+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+:4]),
          .o_bit_field_value      (w_bit_field_value[8+:4]),
          .o_trigger              (o_register_0_bit_field_1_trigger)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+8*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+8*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[16+8*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+8*i+:4]),
          .o_bit_field_value      (w_bit_field_value[16+8*i+:4]),
          .o_trigger              (o_register_0_bit_field_2_trigger[4*(i)+:4])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+8*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+8*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[16+8*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+8*j+:4]),
          .o_bit_field_value      (w_bit_field_value[16+8*j+:4]),
          .o_trigger              (o_register_1_bit_field_2_trigger[4*(2*i+j)+:4])
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+8*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+8*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[16+8*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+8*k+:4]),
          .o_bit_field_value      (w_bit_field_value[16+8*k+:4]),
          .o_trigger              (o_register_2_bit_field_2_trigger[4*(4*i+2*j+k)+:4])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+8*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+8*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[16+8*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+8*m+:4]),
          .o_bit_field_value      (w_bit_field_value[16+8*m+:4]),
          .o_trigger              (o_register_file_3_register_file_0_register_0_bit_field_2_trigger[4*(16*i+8*j+4*k+2*l+m)+:4])
        );
      CODE
    end
  end
end
