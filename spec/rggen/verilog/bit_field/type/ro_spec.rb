# frozen_string_literal: true

RSpec.describe 'bit_field/type/ro' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:ro, :rw])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    create_verilog(&body).bit_fields
  end

  context '参照ビットフィールドを持たない場合' do
    it '入力ポート#value_inを持つ' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :ro }
        end

        register do
          name 'register_2'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro }
        end

        register_file do
          name 'register_file_4'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro }
            end
          end
        end
      end

      expect(bit_fields[0]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_0', direction: :input, width: 1
      )
      expect(bit_fields[1]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_1', direction: :input, width: 2
      )
      expect(bit_fields[2]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_2', direction: :input, width: 4, array_size: [2]
      )

      expect(bit_fields[3]).to have_port(
        :register_block, :value_in,
        name: 'i_register_1_bit_field_0', direction: :input, width: 64
      )

      expect(bit_fields[4]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_0', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[5]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_1', direction: :input, width: 2, array_size: [4]
      )
      expect(bit_fields[6]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_2', direction: :input, width: 4, array_size: [4, 2]
      )

      expect(bit_fields[7]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_0', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[8]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_1', direction: :input, width: 2, array_size: [2, 2]
      )
      expect(bit_fields[9]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_2', direction: :input, width: 4, array_size: [2, 2, 2]
      )

      expect(bit_fields[10]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_0', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[11]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_1', direction: :input, width: 2, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[12]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_2', direction: :input, width: 4, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it '入力ポート#value_inを持たない' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro; reference 'register_5.bit_field_2' }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :ro; reference 'register_5.bit_field_3' }
        end

        register do
          name 'register_2'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro; reference 'register_5.bit_field_2' }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro; reference 'register_5.bit_field_2' }
        end

        register_file do
          name 'register_file_4'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro; reference 'register_5.bit_field_0' }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :ro; reference 'register_5.bit_field_1' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :ro; reference 'register_5.bit_field_2' }
            end
          end
        end

        register do
          name 'register_5'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 32, width: 64; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_0', direction: :input, width: 1
      )
      expect(bit_fields[1]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_1', direction: :input, width: 2
      )
      expect(bit_fields[2]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_2', direction: :input, width: 4, array_size: [2]
      )

      expect(bit_fields[3]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_1_bit_field_0', direction: :input, width: 64
      )

      expect(bit_fields[4]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_0', direction: :input, width: 1, array_size: [4]
      )
      expect(bit_fields[5]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_1', direction: :input, width: 2, array_size: [4]
      )
      expect(bit_fields[6]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_2', direction: :input, width: 4, array_size: [4, 2]
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_0', direction: :input, width: 1, array_size: [2, 2]
      )
      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_1', direction: :input, width: 2, array_size: [2, 2]
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_2', direction: :input, width: 4, array_size: [2, 2, 2]
      )

      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_0', direction: :input, width: 1, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_1', direction: :input, width: 2, array_size: [2, 2, 2, 2]
      )
      expect(bit_fields[10]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_2', direction: :input, width: 4, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  describe '#generate_code' do
    it 'rggen_bit_field_roをインスタンスするコードを生成する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :ro; reference 'register_1.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 8; type :ro }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 16, width: 8; type :ro; reference 'register_1.bit_field_1' }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :ro }
        end

        register do
          name 'register_3'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_4.bit_field_1' }
        end

        register do
          name 'register_4'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_6.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_7.bit_field_0' }
        end

        register do
          name 'register_6'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
        end

        register do
          name 'register_8'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :ro }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_9.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_10.bit_field_0' }
        end

        register do
          name 'register_9'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_10'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_11'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :ro }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_file_12.register_file_0.register_0.bit_field_0' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :ro; reference 'register_file_12.register_file_0.register_1.bit_field_0' }
            end
          end
        end

        register_file do
          name 'register_file_12'
          size [2, 2]
          register_file do
            name 'register_file_0'

            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
            end

            register do
              name 'register_1'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (1)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:1]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:1]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:1]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:1]),
          .o_bit_field_value      (w_bit_field_value[0+:1]),
          .i_value                (i_register_0_bit_field_0)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (1)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[1+:1]),
          .i_bit_field_write_mask (w_bit_field_write_mask[1+:1]),
          .i_bit_field_write_data (w_bit_field_write_data[1+:1]),
          .o_bit_field_read_data  (w_bit_field_read_data[1+:1]),
          .o_bit_field_value      (w_bit_field_value[1+:1]),
          .i_value                (w_register_value[65+:1])
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (8)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+:8]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+:8]),
          .i_bit_field_write_data (w_bit_field_write_data[8+:8]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+:8]),
          .o_bit_field_value      (w_bit_field_value[8+:8]),
          .i_value                (i_register_0_bit_field_2)
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (8)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[16+:8]),
          .i_bit_field_write_mask (w_bit_field_write_mask[16+:8]),
          .i_bit_field_write_data (w_bit_field_write_data[16+:8]),
          .o_bit_field_read_data  (w_bit_field_read_data[16+:8]),
          .o_bit_field_value      (w_bit_field_value[16+:8]),
          .i_value                (w_register_value[80+:8])
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (64)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+:64]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+:64]),
          .i_bit_field_write_data (w_bit_field_write_data[0+:64]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+:64]),
          .o_bit_field_value      (w_bit_field_value[0+:64]),
          .i_value                (i_register_2_bit_field_0)
        );
      CODE

      expect(bit_fields[7]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+16*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+16*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+16*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+16*i+:4]),
          .o_bit_field_value      (w_bit_field_value[0+16*i+:4]),
          .i_value                (i_register_3_bit_field_0[4*(i)+:4])
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[4+16*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[4+16*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[4+16*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[4+16*i+:4]),
          .o_bit_field_value      (w_bit_field_value[4+16*i+:4]),
          .i_value                (w_register_value[260+:4])
        );
      CODE

      expect(bit_fields[9]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+16*i+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+16*i+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[8+16*i+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+16*i+:4]),
          .o_bit_field_value      (w_bit_field_value[8+16*i+:4]),
          .i_value                (w_register_value[256+8+4*i+:4])
        );
      CODE

      expect(bit_fields[12]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+16*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+16*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+16*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+16*j+:4]),
          .o_bit_field_value      (w_bit_field_value[0+16*j+:4]),
          .i_value                (i_register_5_bit_field_0[4*(2*i+j)+:4])
        );
      CODE

      expect(bit_fields[13]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[4+16*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[4+16*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[4+16*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[4+16*j+:4]),
          .o_bit_field_value      (w_bit_field_value[4+16*j+:4]),
          .i_value                (w_register_value[64*(9+i)+4+4*j+:4])
        );
      CODE

      expect(bit_fields[14]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+16*j+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+16*j+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[8+16*j+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+16*j+:4]),
          .o_bit_field_value      (w_bit_field_value[8+16*j+:4]),
          .i_value                (w_register_value[836+:4])
        );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+16*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+16*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+16*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+16*k+:4]),
          .o_bit_field_value      (w_bit_field_value[0+16*k+:4]),
          .i_value                (i_register_8_bit_field_0[4*(4*i+2*j+k)+:4])
        );
      CODE

      expect(bit_fields[18]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[4+16*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[4+16*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[4+16*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[4+16*k+:4]),
          .o_bit_field_value      (w_bit_field_value[4+16*k+:4]),
          .i_value                (w_register_value[64*(18+2*i+j)+4+4*k+:4])
        );
      CODE

      expect(bit_fields[19]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+16*k+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+16*k+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[8+16*k+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+16*k+:4]),
          .o_bit_field_value      (w_bit_field_value[8+16*k+:4]),
          .i_value                (w_register_value[1412+:4])
        );
      CODE

      expect(bit_fields[22]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[0+16*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[0+16*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[0+16*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[0+16*m+:4]),
          .o_bit_field_value      (w_bit_field_value[0+16*m+:4]),
          .i_value                (i_register_file_11_register_file_0_register_0_bit_field_0[4*(16*i+8*j+4*k+2*l+m)+:4])
        );
      CODE

      expect(bit_fields[23]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[4+16*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[4+16*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[4+16*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[4+16*m+:4]),
          .o_bit_field_value      (w_bit_field_value[4+16*m+:4]),
          .i_value                (w_register_value[64*(39+5*(2*i+j)+2*k+l)+4+4*m+:4])
        );
      CODE

      expect(bit_fields[24]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_ro #(
          .WIDTH  (4)
        ) u_bit_field (
          .i_bit_field_valid      (w_bit_field_valid),
          .i_bit_field_read_mask  (w_bit_field_read_mask[8+16*m+:4]),
          .i_bit_field_write_mask (w_bit_field_write_mask[8+16*m+:4]),
          .i_bit_field_write_data (w_bit_field_write_data[8+16*m+:4]),
          .o_bit_field_read_data  (w_bit_field_read_data[8+16*m+:4]),
          .o_bit_field_value      (w_bit_field_value[8+16*m+:4]),
          .i_value                (w_register_value[64*(39+5*(2*i+j)+4)+4+:4])
        );
      CODE
    end
  end
end
