# frozen_string_literal: true

RSpec.describe 'bit_field/type/wrs' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:wrs])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    create_verilog(&body).bit_fields
  end

  it '出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrs; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wrs; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrs; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrs; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrs; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrs; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wrs; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wrs; initial_value 0 }
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
    it 'rggen_bit_field_wrs_woをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wrs; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :wrs; initial_value 0xabcd }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wrs; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrs; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrs; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrs; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wrs; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (1),
          .INITIAL_VALUE  (`rggen_slice(1'h0, 1, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:1]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:1]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:1]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:1]),
          .o_bit_field_value      (w_bit_field_value[0+:1]),
          .o_value                (o_register_0_bit_field_0)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (16),
          .INITIAL_VALUE  (`rggen_slice(16'habcd, 16, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+:16]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+:16]),
          .i_bit_field_write_data (w_bit_field_write_data[16+:16]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+:16]),
          .o_bit_field_value      (w_bit_field_value[16+:16]),
          .o_value                (o_register_0_bit_field_1)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (64),
          .INITIAL_VALUE  (`rggen_slice(64'h0000000000000000, 64, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:64]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:64]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:64]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:64]),
          .o_bit_field_value      (w_bit_field_value[0+:64]),
          .o_value                (o_register_1_bit_field_0)
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (4),
          .INITIAL_VALUE  (`rggen_slice(4'h0, 4, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*i+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*i+:4]),
          .o_value                (o_register_2_bit_field_0[4*(i)+:4])
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (4),
          .INITIAL_VALUE  (`rggen_slice(4'h0, 4, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*j+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*j+:4]),
          .o_value                (o_register_3_bit_field_0[4*(4*i+j)+:4])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (4),
          .INITIAL_VALUE  (`rggen_slice(4'h0, 4, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*k+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*k+:4]),
          .o_value                (o_register_4_bit_field_0[4*(8*i+4*j+k)+:4])
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_wrs #(
          .WIDTH          (4),
          .INITIAL_VALUE  (`rggen_slice(4'h0, 4, 0))
        ) u_bit_field (
          .i_clk                  (i_clk),
          .i_rst_n                (i_rst_n),
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*m+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*m+:4]),
          .o_value                (o_register_file_5_register_file_0_register_0_bit_field_0[4*(32*i+16*j+8*k+4*l+m)+:4])
        );
      CODE
    end
  end
end