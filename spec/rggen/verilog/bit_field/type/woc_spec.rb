# frozen_string_literal: true

RSpec.describe 'bit_field/type/woc' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:woc, :rw])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    create_verilog(&body).bit_fields
  end

  it '入力ポート#set/出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :woc; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_0_set', direction: :input, width: 1
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, width: 1
    )

    expect(bit_fields[1]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_1_set', direction: :input, width: 2
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :output, width: 2
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_2_set', direction: :input, width: 4, array_size: [2]
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, width: 4, array_size: [2]
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :set,
      name: 'i_register_1_bit_field_0_set', direction: :input, width: 64
    )
    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_0_set', direction: :input, width: 1, array_size: [4]
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, width: 1, array_size: [4]
    )

    expect(bit_fields[5]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_1_set', direction: :input, width: 2, array_size: [4]
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :output, width: 2, array_size: [4]
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_2_set', direction: :input, width: 4, array_size: [4, 2]
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, width: 4, array_size: [4, 2]
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_0_set', direction: :input, width: 1, array_size: [2, 2]
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :output, width: 1, array_size: [2, 2]
    )

    expect(bit_fields[8]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_1_set', direction: :input, width: 2, array_size: [2, 2]
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :output, width: 2, array_size: [2, 2]
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_2_set', direction: :input, width: 4, array_size: [2, 2, 2]
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :output, width: 4, array_size: [2, 2, 2]
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_0_set', direction: :input, width: 1, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :output, width: 1, array_size: [2, 2, 2, 2]
    )

    expect(bit_fields[11]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_1_set', direction: :input, width: 2, array_size: [2, 2, 2, 2]
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :output, width: 2, array_size: [2, 2, 2, 2]
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_2_set', direction: :input, width: 4, array_size: [2, 2, 2, 2, 2]
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
    )
  end

  context '参照信号を持つ場合' do
    it '出力ポート#value_unmaskedを持つ' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register_file do
          name 'register_file_3'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0; reference 'register_4.bit_field_0' }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0; reference 'register_4.bit_field_1' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0; reference 'register_4.bit_field_2' }
            end
          end
        end

        register do
          name 'register_4'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_0_unmasked', direction: :output, width: 1
      )

      expect(bit_fields[1]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_1_unmasked', direction: :output, width: 2
      )

      expect(bit_fields[2]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2]
      )

      expect(bit_fields[3]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_0_unmasked', direction: :output, width: 1, array_size: [4]
      )

      expect(bit_fields[4]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_1_unmasked', direction: :output, width: 2, array_size: [4]
      )

      expect(bit_fields[5]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_2_unmasked', direction: :output, width: 4, array_size: [4, 2]
      )

      expect(bit_fields[6]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_0_unmasked', direction: :output, width: 1, array_size: [2, 2]
      )

      expect(bit_fields[7]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_1_unmasked', direction: :output, width: 2, array_size: [2, 2]
      )

      expect(bit_fields[8]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2, 2, 2]
      )

      expect(bit_fields[9]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_0_unmasked', direction: :output, width: 1, array_size: [2, 2, 2, 2]
      )

      expect(bit_fields[10]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_1_unmasked', direction: :output, width: 2, array_size: [2, 2, 2, 2]
      )

      expect(bit_fields[11]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  context '参照信号を持たない場合' do
    it '出力ポート#value_unmaskedを持たない' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
        end

        register_file do
          name 'register_file_3'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :woc; initial_value 0 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :woc; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_0_unmasked', direction: :output, width: 1
      )

      expect(bit_fields[1]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_1_unmasked', direction: :output, width: 2
      )

      expect(bit_fields[2]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2]
      )

      expect(bit_fields[3]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_0_unmasked', direction: :output, width: 1, array_size: [4]
      )

      expect(bit_fields[4]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_1_unmasked', direction: :output, width: 2, array_size: [4]
      )

      expect(bit_fields[5]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_2_unmasked', direction: :output, width: 4, array_size: [4, 2]
      )

      expect(bit_fields[6]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_0_unmasked', direction: :output, width: 1, array_size: [2, 2]
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_1_unmasked', direction: :output, width: 2, array_size: [2, 2]
      )

      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2, 2, 2]
      )

      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_0_unmasked', direction: :output, width: 1, array_size: [2, 2, 2, 2]
      )

      expect(bit_fields[10]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_1_unmasked', direction: :output, width: 2, array_size: [2, 2, 2, 2]
      )

      expect(bit_fields[11]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_2_unmasked', direction: :output, width: 4, array_size: [2, 2, 2, 2, 2]
      )
    end
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを生成する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :woc; reference 'register_6.bit_field_0'; initial_value 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 8; type :woc; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 16, width: 8; type :woc; reference 'register_6.bit_field_2'; initial_value 0xab }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :woc; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :woc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :woc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :woc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :woc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :woc; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :woc; reference 'register_file_7.register_file_0.register_0.bit_field_0'; initial_value 0 }
            end
          end
        end

        register do
          name 'register_6'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_7'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 8, width: 4; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (`rggen_slice(1'h0, 1, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_0_bit_field_0_set),
          .i_hw_clear         ({1{1'b0}}),
          .i_value            ({1{1'b0}}),
          .i_mask             ({1{1'b1}}),
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (`rggen_slice(1'h1, 1, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[1+:1]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[1+:1]),
          .i_sw_write_data    (w_bit_field_write_data[1+:1]),
          .o_sw_read_data     (w_bit_field_read_data[1+:1]),
          .o_sw_value         (w_bit_field_value[1+:1]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({1{1'b0}}),
          .i_hw_set           (i_register_0_bit_field_1_set),
          .i_hw_clear         ({1{1'b0}}),
          .i_value            ({1{1'b0}}),
          .i_mask             (w_register_value[1728+:1]),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   (o_register_0_bit_field_1_unmasked)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (8),
          .INITIAL_VALUE    (`rggen_slice(8'h00, 8, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[8+:8]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[8+:8]),
          .i_sw_write_data    (w_bit_field_write_data[8+:8]),
          .o_sw_read_data     (w_bit_field_read_data[8+:8]),
          .o_sw_value         (w_bit_field_value[8+:8]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({8{1'b0}}),
          .i_hw_set           (i_register_0_bit_field_2_set),
          .i_hw_clear         ({8{1'b0}}),
          .i_value            ({8{1'b0}}),
          .i_mask             ({8{1'b1}}),
          .o_value            (o_register_0_bit_field_2),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (8),
          .INITIAL_VALUE    (`rggen_slice(8'hab, 8, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[16+:8]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[16+:8]),
          .i_sw_write_data    (w_bit_field_write_data[16+:8]),
          .o_sw_read_data     (w_bit_field_read_data[16+:8]),
          .o_sw_value         (w_bit_field_value[16+:8]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({8{1'b0}}),
          .i_hw_set           (i_register_0_bit_field_3_set),
          .i_hw_clear         ({8{1'b0}}),
          .i_value            ({8{1'b0}}),
          .i_mask             (w_register_value[1744+:8]),
          .o_value            (o_register_0_bit_field_3),
          .o_value_unmasked   (o_register_0_bit_field_3_unmasked)
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (64),
          .INITIAL_VALUE    (`rggen_slice(64'h0000000000000000, 64, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_1_bit_field_0_set),
          .i_hw_clear         ({64{1'b0}}),
          .i_value            ({64{1'b0}}),
          .i_mask             ({64{1'b1}}),
          .o_value            (o_register_1_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_2_bit_field_0_set[4*(i)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_2_bit_field_0[4*(i)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[4+8*i+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[4+8*i+:4]),
          .i_sw_write_data    (w_bit_field_write_data[4+8*i+:4]),
          .o_sw_read_data     (w_bit_field_read_data[4+8*i+:4]),
          .o_sw_value         (w_bit_field_value[4+8*i+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           (i_register_2_bit_field_1_set[4*(i)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             (w_register_value[1736+:4]),
          .o_value            (o_register_2_bit_field_1[4*(i)+:4]),
          .o_value_unmasked   (o_register_2_bit_field_1_unmasked[4*(i)+:4])
        );
      CODE

      expect(bit_fields[7]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_3_bit_field_0_set[4*(4*i+j)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_3_bit_field_0[4*(4*i+j)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[4+8*j+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[4+8*j+:4]),
          .i_sw_write_data    (w_bit_field_write_data[4+8*j+:4]),
          .o_sw_read_data     (w_bit_field_read_data[4+8*j+:4]),
          .o_sw_value         (w_bit_field_value[4+8*j+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           (i_register_3_bit_field_1_set[4*(4*i+j)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             (w_register_value[1736+:4]),
          .o_value            (o_register_3_bit_field_1[4*(4*i+j)+:4]),
          .o_value_unmasked   (o_register_3_bit_field_1_unmasked[4*(4*i+j)+:4])
        );
      CODE

      expect(bit_fields[9]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_4_bit_field_0_set[4*(8*i+4*j+k)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_4_bit_field_0[4*(8*i+4*j+k)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[4+8*k+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[4+8*k+:4]),
          .i_sw_write_data    (w_bit_field_write_data[4+8*k+:4]),
          .o_sw_read_data     (w_bit_field_read_data[4+8*k+:4]),
          .o_sw_value         (w_bit_field_value[4+8*k+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           (i_register_4_bit_field_1_set[4*(8*i+4*j+k)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             (w_register_value[1736+:4]),
          .o_value            (o_register_4_bit_field_1[4*(8*i+4*j+k)+:4]),
          .o_value_unmasked   (o_register_4_bit_field_1_unmasked[4*(8*i+4*j+k)+:4])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
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
          .i_hw_set           (i_register_file_5_register_file_0_register_0_bit_field_0_set[4*(32*i+16*j+8*k+4*l+m)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             ({4{1'b1}}),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_0[4*(32*i+16*j+8*k+4*l+m)+:4]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[12]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (`rggen_slice(4'h0, 4, 0)),
          .SW_READ_ACTION   (`RGGEN_READ_NONE),
          .SW_WRITE_ACTION  (`RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .i_sw_valid         (w_bit_field_valid),
          .i_sw_read_mask     (w_bit_field_read_mask[4+8*m+:4]),
          .i_sw_write_enable  (1'b1),
          .i_sw_write_mask    (w_bit_field_write_mask[4+8*m+:4]),
          .i_sw_write_data    (w_bit_field_write_data[4+8*m+:4]),
          .o_sw_read_data     (w_bit_field_read_data[4+8*m+:4]),
          .o_sw_value         (w_bit_field_value[4+8*m+:4]),
          .o_write_trigger    (),
          .o_read_trigger     (),
          .i_hw_write_enable  (1'b0),
          .i_hw_write_data    ({4{1'b0}}),
          .i_hw_set           (i_register_file_5_register_file_0_register_0_bit_field_1_set[4*(32*i+16*j+8*k+4*l+m)+:4]),
          .i_hw_clear         ({4{1'b0}}),
          .i_value            ({4{1'b0}}),
          .i_mask             (w_register_value[64*(28+2*i+j)+8+:4]),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_1[4*(32*i+16*j+8*k+4*l+m)+:4]),
          .o_value_unmasked   (o_register_file_5_register_file_0_register_0_bit_field_1_unmasked[4*(32*i+16*j+8*k+4*l+m)+:4])
        );
      CODE
    end
  end
end
