# frozen_string_literal: true

RSpec.describe 'register/verilog_rtl_header' do
  include_context 'clean-up builder'
  include_context 'verilog rtl header common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register, :verilog_rtl_header)
  end

  let(:verilog_rtl_header) do
    verilog_rtl_header = create_verilog_rtl_header do
      name 'block_0'
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { name 'bit_field_0'; bit_assignment lsb: 32, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_3'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_4'
        offset_address 0x10
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x20
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x30
        size [4]
        type [:indirect, 'register_0.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x34
        size [2, 2]
        type [:indirect, 'register_0.bit_field_0', 'register_1.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_8'
        offset_address 0x40
        size [4]
        type :external
      end

      register_file do
        name 'register_file_9'
        offset_address 0x50

        register do
          name 'register_9_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_9_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_9_2'
          offset_address 0x10

          register do
            name 'register_9_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_9_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_10'
        offset_address 0x70
        size [2, 2]

        register do
          name 'register_10_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_10_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_10_2'
          offset_address 0x10

          register do
            name 'register_10_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_10_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end
    end
    verilog_rtl_header.registers
  end

  describe 'マクロ定義' do
    it 'バイト幅/バイト長/配列次元/配列長/オフセットアドレスを示すマクロを定義する' do
      expect(verilog_rtl_header[0].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_0_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_0_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_0_BYTE_OFFSET', "8'h00")
      ])

      expect(verilog_rtl_header[1].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_1_BYTE_WIDTH', 8),
        match_macro_definition('#define BLOCK_0_REGISTER_1_BYTE_SIZE', 8),
        match_macro_definition('#define BLOCK_0_REGISTER_1_BYTE_OFFSET', "8'h04")
      ])

      expect(verilog_rtl_header[2].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_2_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_2_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_2_BYTE_OFFSET', "8'h0c")
      ])

      expect(verilog_rtl_header[3].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_3_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_3_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_3_BYTE_OFFSET', "8'h0c")
      ])

      expect(verilog_rtl_header[4].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_SIZE', 16),
        match_macro_definition('#define BLOCK_0_REGISTER_4_ARRAY_DIMENSION', 1),
        match_macro_definition('#define BLOCK_0_REGISTER_4_ARRAY_SIZE_0', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_OFFSET_0', "8'h10"),
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_OFFSET_1', "8'h14"),
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_OFFSET_2', "8'h18"),
        match_macro_definition('#define BLOCK_0_REGISTER_4_BYTE_OFFSET_3', "8'h1c")
      ])

      expect(verilog_rtl_header[5].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_SIZE', 16),
        match_macro_definition('#define BLOCK_0_REGISTER_5_ARRAY_DIMENSION', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_5_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_5_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_OFFSET_0_0', "8'h20"),
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_OFFSET_0_1', "8'h24"),
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_OFFSET_1_0', "8'h28"),
        match_macro_definition('#define BLOCK_0_REGISTER_5_BYTE_OFFSET_1_1', "8'h2c")
      ])

      expect(verilog_rtl_header[6].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_6_ARRAY_DIMENSION', 1),
        match_macro_definition('#define BLOCK_0_REGISTER_6_ARRAY_SIZE_0', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_OFFSET_0', "8'h30"),
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_OFFSET_1', "8'h30"),
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_OFFSET_2', "8'h30"),
        match_macro_definition('#define BLOCK_0_REGISTER_6_BYTE_OFFSET_3', "8'h30")
      ])

      expect(verilog_rtl_header[7].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_7_ARRAY_DIMENSION', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_7_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_7_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_OFFSET_0_0', "8'h34"),
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_OFFSET_0_1', "8'h34"),
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_OFFSET_1_0', "8'h34"),
        match_macro_definition('#define BLOCK_0_REGISTER_7_BYTE_OFFSET_1_1', "8'h34")
      ])

      expect(verilog_rtl_header[8].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_8_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_8_BYTE_SIZE', 16),
        match_macro_definition('#define BLOCK_0_REGISTER_8_BYTE_OFFSET', "8'h40")
      ])

      expect(verilog_rtl_header[9].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_0_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_0_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_0_BYTE_OFFSET', "8'h50")
      ])

      expect(verilog_rtl_header[10].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_BYTE_SIZE', 8),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_ARRAY_DIMENSION', 1),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_BYTE_OFFSET_0', "8'h58"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_9_1_BYTE_OFFSET_1', "8'h5c")
      ])

      expect(verilog_rtl_header[11].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_SIZE', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_OFFSET', "8'h60")
      ])

      expect(verilog_rtl_header[12].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_SIZE', 8),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_ARRAY_DIMENSION', 1),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_OFFSET_0', "8'h68"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_OFFSET_1', "8'h6c")
      ])

      expect(verilog_rtl_header[13].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_SIZE', 16),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_ARRAY_DIMENSION', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET_0_0', "8'h70"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET_0_1', "8'h90"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET_1_0', "8'hb0"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET_1_1', "8'hd0")
      ])

      expect(verilog_rtl_header[14].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_SIZE', 32),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_DIMENSION', 3),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_SIZE_2', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_0_0_0', "8'h78"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_0_0_1', "8'h7c"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_0_1_0', "8'h98"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_0_1_1', "8'h9c"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_1_0_0', "8'hb8"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_1_0_1', "8'hbc"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_1_1_0', "8'hd8"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_1_1_1', "8'hdc")
      ])

      expect(verilog_rtl_header[15].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_SIZE', 16),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_ARRAY_DIMENSION', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET_0_0', "8'h80"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET_0_1', "8'ha0"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET_1_0', "8'hc0"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET_1_1', "8'he0")
      ])

      expect(verilog_rtl_header[16].macro_definitions).to match([
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_WIDTH', 4),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_SIZE', 32),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_DIMENSION', 3),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_SIZE_0', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_SIZE_1', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_SIZE_2', 2),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_0_0_0', "8'h88"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_0_0_1', "8'h8c"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_0_1_0', "8'ha8"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_0_1_1', "8'hac"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_1_0_0', "8'hc8"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_1_0_1', "8'hcc"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_1_1_0', "8'he8"),
        match_macro_definition('#define BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_1_1_1', "8'hec")
      ])
    end
  end
end
