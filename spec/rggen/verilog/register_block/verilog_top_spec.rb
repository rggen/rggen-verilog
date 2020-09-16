# frozen_string_literal: true

RSpec.describe 'register_block/verilog_top' do
  include_context 'verilog common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :bus_width])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:register_block, [:verilog_top])
  end

  def create_register_block(&body)
    create_verilog(&body).register_blocks.first
  end

  let(:bus_width) { default_configuration.bus_width }

  let(:address_width) { 8 }

  describe 'clock/reset' do
    it 'clock/resetを持つ' do
      register_block = create_register_block { name 'block_0'; byte_size 256 }
      expect(register_block).to have_port(
        :clock,
        name: 'i_clk', direction: :input, width: 1
      )
      expect(register_block).to have_port(
        :reset,
        name: 'i_rst_n', direction: :input, width: 1
      )
    end
  end

  describe 'レジスタアクセス' do
    def check_register_signals(register_block, array_size, value_width)
      expect(register_block).to have_wire(
        :register_valid,
        name: 'w_register_valid', width: 1
      )
      expect(register_block).to have_wire(
        :register_write,
        name: 'w_register_write', width: 1
      )
      expect(register_block).to have_wire(
        :register_address,
        name: 'w_register_address', width: address_width
      )
      expect(register_block).to have_wire(
        :register_write_data,
        name: 'w_register_write_data', width: bus_width
      )
      expect(register_block).to have_wire(
        :register_strobe,
        name: 'w_register_strobe', width: bus_width / 8
      )
      expect(register_block).to have_wire(
        :register_active,
        name: 'w_register_active', width: 1, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_ready,
        name: 'w_register_ready', width: 1, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_status,
        name: 'w_register_status', width: 2, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_read_data,
        name: 'w_register_read_data', width: bus_width, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_value,
        name: 'w_register_value', width: value_width, array_size: [array_size]
      )
    end

    it 'レジスタアクセス用の信号群を持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 1, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [2, 4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 8, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
        register do
          name 'register_1'
          offset_address 0x10
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
        register do
          name 'register_2'
          offset_address 0x20
          bit_field { name 'bit_field_0'; bit_assignment lsb: 64; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 3, 3 * bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256

        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            end
            register do
              name 'register_1'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
            end
          end
        end
      end
      check_register_signals(register_block, 25, 2 * bus_width)
    end
  end
end