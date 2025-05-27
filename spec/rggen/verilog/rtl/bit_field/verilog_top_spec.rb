# frozen_string_literal: true

RSpec.describe 'bit_field/verilog_top' do
  include_context 'verilog rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size, :bus_width])
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
    create_verilog_rtl(&body).bit_fields
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
      it '配列の各要素を結合した値を初期値リテラルとして返す' do
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
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [[0], [1]] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [[1, 2], [3, 4]] }
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
              bit_field {
                name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1
                type :rw; initial_value [[[0], [1]], [[2], [3]]]
              }
              bit_field {
                name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2
                type :rw; initial_value [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
              }
            end
          end
        end

        expect(bit_fields[0].initial_value).to eq "8'h00"
        expect(bit_fields[1].initial_value).to eq "16'h0201"
        expect(bit_fields[2].initial_value).to eq "16'h0100"
        expect(bit_fields[3].initial_value).to eq "32'h04030201"
        expect(bit_fields[4].initial_value).to eq "8'h00"
        expect(bit_fields[5].initial_value).to eq "16'h0201"
        expect(bit_fields[6].initial_value).to eq "32'h03020100"
        expect(bit_fields[7].initial_value).to eq "64'h0807060504030201"
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
        width: 1, array_size: [2], default: "{2{1'h0}}"
      )
      expect(bit_fields[4]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2], default: "{2{8'h01}}"
      )
      expect(bit_fields[5]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2, 2], default: "{4{8'h02}}"
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
        width: 1, array_size: [2, 2], default: "{4{1'h0}}"
      )
      expect(bit_fields[10]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2, 2], default: "{4{8'h01}}"
      )
      expect(bit_fields[11]).to have_parameter(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', parameter_type: :parameter,
        width: 8, array_size: [2, 2, 2], array_format: :serialized, default: "{8{8'h02}}"
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

  describe '#generate_code' do
    it 'ビットフィールド階層のコードを出力する' do
      bit_fields = create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field {
            name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4
            type :rw; initial_value [[0, 1], [2, 3], [3, 2], [1, 0]]
          }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field {
            name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4
            type :rw; initial_value [[[0, 1], [2, 3]], [[3, 2], [1, 0]]]
          }
        end

        register do
          name 'register_3'
          offset_address 0x30
          bit_field { bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (1'h0),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
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
            .i_hw_clear         ({1{1'b0}}),
            .i_value            ({1{1'b0}}),
            .i_mask             ({1{1'b1}}),
            .o_value            (o_register_0_bit_field_0),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[1]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (8'h00),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .i_sw_read_valid    (w_bit_field_read_valid),
            .i_sw_write_valid   (w_bit_field_write_valid),
            .i_sw_write_enable  (1'b1),
            .i_sw_mask          (w_bit_field_mask[8+:8]),
            .i_sw_write_data    (w_bit_field_write_data[8+:8]),
            .o_sw_read_data     (w_bit_field_read_data[8+:8]),
            .o_sw_value         (w_bit_field_value[8+:8]),
            .o_write_trigger    (),
            .o_read_trigger     (),
            .i_hw_write_enable  (1'b0),
            .i_hw_write_data    ({8{1'b0}}),
            .i_hw_set           ({8{1'b0}}),
            .i_hw_clear         ({8{1'b0}}),
            .i_value            ({8{1'b0}}),
            .i_mask             ({8{1'b1}}),
            .o_value            (o_register_0_bit_field_1),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[2]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar i;
          for (i = 0;i < 2;i = i + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (1'h0),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[16+1*i+:1]),
              .i_sw_write_data    (w_bit_field_write_data[16+1*i+:1]),
              .o_sw_read_data     (w_bit_field_read_data[16+1*i+:1]),
              .o_sw_value         (w_bit_field_value[16+1*i+:1]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({1{1'b0}}),
              .i_hw_set           ({1{1'b0}}),
              .i_hw_clear         ({1{1'b0}}),
              .i_value            ({1{1'b0}}),
              .i_mask             ({1{1'b1}}),
              .o_value            (o_register_0_bit_field_2[1*(i)+:1]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[3]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar i;
          for (i = 0;i < 2;i = i + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(REGISTER_0_BIT_FIELD_3_INITIAL_VALUE, 4, 2, i)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[20+2*i+:2]),
              .i_sw_write_data    (w_bit_field_write_data[20+2*i+:2]),
              .o_sw_read_data     (w_bit_field_read_data[20+2*i+:2]),
              .o_sw_value         (w_bit_field_value[20+2*i+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_0_bit_field_3[2*(i)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[4]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar i;
          for (i = 0;i < 2;i = i + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(4'h4, 4, 2, i)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[24+4*i+:2]),
              .i_sw_write_data    (w_bit_field_write_data[24+4*i+:2]),
              .o_sw_read_data     (w_bit_field_read_data[24+4*i+:2]),
              .o_sw_value         (w_bit_field_value[24+4*i+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_0_bit_field_4[2*(i)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[5]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (1'h0),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
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
            .i_hw_clear         ({1{1'b0}}),
            .i_value            ({1{1'b0}}),
            .i_mask             ({1{1'b1}}),
            .o_value            (o_register_1_bit_field_0[1*(i)+:1]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[6]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (8'h00),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .i_sw_read_valid    (w_bit_field_read_valid),
            .i_sw_write_valid   (w_bit_field_write_valid),
            .i_sw_write_enable  (1'b1),
            .i_sw_mask          (w_bit_field_mask[8+:8]),
            .i_sw_write_data    (w_bit_field_write_data[8+:8]),
            .o_sw_read_data     (w_bit_field_read_data[8+:8]),
            .o_sw_value         (w_bit_field_value[8+:8]),
            .o_write_trigger    (),
            .o_read_trigger     (),
            .i_hw_write_enable  (1'b0),
            .i_hw_write_data    ({8{1'b0}}),
            .i_hw_set           ({8{1'b0}}),
            .i_hw_clear         ({8{1'b0}}),
            .i_value            ({8{1'b0}}),
            .i_mask             ({8{1'b1}}),
            .o_value            (o_register_1_bit_field_1[8*(i)+:8]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[7]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar j;
          for (j = 0;j < 2;j = j + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (1'h0),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[16+1*j+:1]),
              .i_sw_write_data    (w_bit_field_write_data[16+1*j+:1]),
              .o_sw_read_data     (w_bit_field_read_data[16+1*j+:1]),
              .o_sw_value         (w_bit_field_value[16+1*j+:1]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({1{1'b0}}),
              .i_hw_set           ({1{1'b0}}),
              .i_hw_clear         ({1{1'b0}}),
              .i_value            ({1{1'b0}}),
              .i_mask             ({1{1'b1}}),
              .o_value            (o_register_1_bit_field_2[1*(2*i+j)+:1]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[8]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar j;
          for (j = 0;j < 2;j = j + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(REGISTER_1_BIT_FIELD_3_INITIAL_VALUE, 16, 2, 2*i+j)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[20+2*j+:2]),
              .i_sw_write_data    (w_bit_field_write_data[20+2*j+:2]),
              .o_sw_read_data     (w_bit_field_read_data[20+2*j+:2]),
              .o_sw_value         (w_bit_field_value[20+2*j+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_1_bit_field_3[2*(2*i+j)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[9]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar j;
          for (j = 0;j < 2;j = j + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(16'h1be4, 16, 2, 2*i+j)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[24+4*j+:2]),
              .i_sw_write_data    (w_bit_field_write_data[24+4*j+:2]),
              .o_sw_read_data     (w_bit_field_read_data[24+4*j+:2]),
              .o_sw_value         (w_bit_field_value[24+4*j+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_1_bit_field_4[2*(2*i+j)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[10]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (1'h0),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
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
            .i_hw_clear         ({1{1'b0}}),
            .i_value            ({1{1'b0}}),
            .i_mask             ({1{1'b1}}),
            .o_value            (o_register_2_bit_field_0[1*(2*i+j)+:1]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[11]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (8'h00),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .i_sw_read_valid    (w_bit_field_read_valid),
            .i_sw_write_valid   (w_bit_field_write_valid),
            .i_sw_write_enable  (1'b1),
            .i_sw_mask          (w_bit_field_mask[8+:8]),
            .i_sw_write_data    (w_bit_field_write_data[8+:8]),
            .o_sw_read_data     (w_bit_field_read_data[8+:8]),
            .o_sw_value         (w_bit_field_value[8+:8]),
            .o_write_trigger    (),
            .o_read_trigger     (),
            .i_hw_write_enable  (1'b0),
            .i_hw_write_data    ({8{1'b0}}),
            .i_hw_set           ({8{1'b0}}),
            .i_hw_clear         ({8{1'b0}}),
            .i_value            ({8{1'b0}}),
            .i_mask             ({8{1'b1}}),
            .o_value            (o_register_2_bit_field_1[8*(2*i+j)+:8]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[12]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar k;
          for (k = 0;k < 2;k = k + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (1'h0),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[16+1*k+:1]),
              .i_sw_write_data    (w_bit_field_write_data[16+1*k+:1]),
              .o_sw_read_data     (w_bit_field_read_data[16+1*k+:1]),
              .o_sw_value         (w_bit_field_value[16+1*k+:1]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({1{1'b0}}),
              .i_hw_set           ({1{1'b0}}),
              .i_hw_clear         ({1{1'b0}}),
              .i_value            ({1{1'b0}}),
              .i_mask             ({1{1'b1}}),
              .o_value            (o_register_2_bit_field_2[1*(4*i+2*j+k)+:1]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[13]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar k;
          for (k = 0;k < 2;k = k + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(REGISTER_2_BIT_FIELD_3_INITIAL_VALUE, 16, 2, 4*i+2*j+k)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[20+2*k+:2]),
              .i_sw_write_data    (w_bit_field_write_data[20+2*k+:2]),
              .o_sw_read_data     (w_bit_field_read_data[20+2*k+:2]),
              .o_sw_value         (w_bit_field_value[20+2*k+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_2_bit_field_3[2*(4*i+2*j+k)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[14]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar k;
          for (k = 0;k < 2;k = k + 1) begin : g
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (`rggen_slice(16'h1be4, 16, 2, 4*i+2*j+k)),
              .SW_WRITE_ONCE  (0),
              .TRIGGER        (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .i_sw_read_valid    (w_bit_field_read_valid),
              .i_sw_write_valid   (w_bit_field_write_valid),
              .i_sw_write_enable  (1'b1),
              .i_sw_mask          (w_bit_field_mask[24+4*k+:2]),
              .i_sw_write_data    (w_bit_field_write_data[24+4*k+:2]),
              .o_sw_read_data     (w_bit_field_read_data[24+4*k+:2]),
              .o_sw_value         (w_bit_field_value[24+4*k+:2]),
              .o_write_trigger    (),
              .o_read_trigger     (),
              .i_hw_write_enable  (1'b0),
              .i_hw_write_data    ({2{1'b0}}),
              .i_hw_set           ({2{1'b0}}),
              .i_hw_clear         ({2{1'b0}}),
              .i_value            ({2{1'b0}}),
              .i_mask             ({2{1'b1}}),
              .o_value            (o_register_2_bit_field_4[2*(4*i+2*j+k)+:2]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[15]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_register_3
          rggen_bit_field #(
            .WIDTH          (32),
            .INITIAL_VALUE  (32'h00000000),
            .SW_WRITE_ONCE  (0),
            .TRIGGER        (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .i_sw_read_valid    (w_bit_field_read_valid),
            .i_sw_write_valid   (w_bit_field_write_valid),
            .i_sw_write_enable  (1'b1),
            .i_sw_mask          (w_bit_field_mask[0+:32]),
            .i_sw_write_data    (w_bit_field_write_data[0+:32]),
            .o_sw_read_data     (w_bit_field_read_data[0+:32]),
            .o_sw_value         (w_bit_field_value[0+:32]),
            .o_write_trigger    (),
            .o_read_trigger     (),
            .i_hw_write_enable  (1'b0),
            .i_hw_write_data    ({32{1'b0}}),
            .i_hw_set           ({32{1'b0}}),
            .i_hw_clear         ({32{1'b0}}),
            .i_value            ({32{1'b0}}),
            .i_mask             ({32{1'b1}}),
            .o_value            (o_register_3),
            .o_value_unmasked   ()
          );
        end
      CODE
    end
  end
end
