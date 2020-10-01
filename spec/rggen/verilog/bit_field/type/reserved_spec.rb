# frozen_string_literal: true

RSpec.describe 'bit_field/type/reserved' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:reserved, :rw])
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    create_verilog(&body).bit_fields
  end

  describe '#generate_code' do
    it 'rggen_bit_field_reservedをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :reserved }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :reserved }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :reserved }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'regsiter_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (1)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:1]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:1]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:1]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:1]),
          .o_bit_field_value      (w_bit_field_value[0+:1])
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (16)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+:16]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+:16]),
          .i_bit_field_write_data (w_bit_field_write_data[16+:16]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+:16]),
          .o_bit_field_value      (w_bit_field_value[16+:16])
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (64)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:64]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:64]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:64]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:64]),
          .o_bit_field_value      (w_bit_field_value[0+:64])
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*i+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*i+:4])
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*j+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*j+:4])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*k+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*k+:4])
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_reserved #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+8*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+8*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+8*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+8*m+:4]),
          .o_bit_field_value      (w_bit_field_value[0+8*m+:4])
        );
      CODE
    end
  end
end
