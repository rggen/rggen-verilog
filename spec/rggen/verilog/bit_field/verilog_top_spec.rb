# frozen_string_literal: true

RSpec.describe 'bit_field/verilog_top' do
  include_context 'verilog common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    create_verilog(&body).bit_fields
  end

  context '単一の初期値が指定されている場合' do
    describe '#initial_value' do
      it '初期値リテラルを返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end
        end

        expect(bit_fields[0].initial_value).to eq "1'h0"
        expect(bit_fields[1].initial_value).to eq "8'h01"
        expect(bit_fields[2].initial_value).to eq "8'h02"
        expect(bit_fields[3].initial_value).to eq "1'h0"
        expect(bit_fields[4].initial_value).to eq "8'h01"
        expect(bit_fields[5].initial_value).to eq "8'h02"
        expect(bit_fields[6].initial_value).to eq "1'h0"
        expect(bit_fields[7].initial_value).to eq "8'h01"
        expect(bit_fields[8].initial_value).to eq "8'h02"
        expect(bit_fields[9].initial_value).to eq "1'h0"
        expect(bit_fields[10].initial_value).to eq "8'h01"
        expect(bit_fields[11].initial_value).to eq "8'h02"
      end
    end
  end

  context '配列化された初期値が指定されている場合' do
    describe '#initial_value' do
      it '配列の各要素の連接を初期値リテラルとして返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end
        end

        expect(bit_fields[0].initial_value).to eq "{8'h00}"
        expect(bit_fields[1].initial_value).to eq "{8'h02, 8'h01}"
        expect(bit_fields[2].initial_value).to eq "{8'h00}"
        expect(bit_fields[3].initial_value).to eq "{8'h02, 8'h01}"
        expect(bit_fields[4].initial_value).to eq "{8'h00}"
        expect(bit_fields[5].initial_value).to eq "{8'h02, 8'h01}"
        expect(bit_fields[6].initial_value).to eq "{8'h00}"
        expect(bit_fields[7].initial_value).to eq "{8'h02, 8'h01}"
      end
    end
  end

  context 'パラメータ化された初期値が指定されている場合' do
    let(:bit_fields) do
      create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
        end

        register do
          name 'register_1'
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
        end

        register_file do
          name 'register_file_2'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end
        end

        register_file do
          name 'register_file_3'
          size [2]
          register do
            name 'register_0'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end
        end
      end
    end

    it 'パラメータ#initial_valueを持つ' do
      expect(bit_fields[0]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', parameter_type: :parameter,
        width: 1, default: "1'h0"
      )
      expect(bit_fields[1]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, default: "8'h01"
      )
      expect(bit_fields[2]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
      )
      expect(bit_fields[3]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_0_INITIAL_VALUE', parameter_type: :parameter,
        width: 1, default: "1'h0"
      )
      expect(bit_fields[4]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, default: "8'h01"
      )
      expect(bit_fields[5]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2], default: "{2{8'h02}}"
      )
      expect(bit_fields[6]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', parameter_type: :parameter,
        width: 1, default: "1'h0"
      )
      expect(bit_fields[7]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, default: "8'h01"
      )
      expect(bit_fields[8]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
      )
      expect(bit_fields[9]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', parameter_type: :parameter,
        width: 1, default: "1'h0"
      )
      expect(bit_fields[10]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, default: "8'h01"
      )
      expect(bit_fields[11]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
      )
    end

    describe '#initial_value' do
      it 'パラメータの識別子を返す' do
        expect(bit_fields[0].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[1].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[2].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[3].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[4].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[5].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[6].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[7].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[8].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[9].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[10].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[11].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
      end
    end
  end
end
