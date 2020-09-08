# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :verilog_top) do
  verilog do
    build do
      input :clock, {
        name: 'i_clk', width: 1
      }
      input :reset, {
        name: 'i_rst_n', width: 1
      }

      wire :register_valid, {
        name: 'w_register_valid', width: 1
      }
      wire :register_write, {
        name: 'w_register_write', width: 1
      }
      wire :register_address, {
        name: 'w_register_address', width: address_width
      }
      wire :register_write_data, {
        name: 'w_register_write_data', width: bus_width
      }
      wire :register_strobe, {
        name: 'w_register_strobe', width: bus_width / 8
      }
      wire :register_active, {
        name: 'w_register_active', width: 1, array_size: [total_registers]
      }
      wire :register_ready, {
        name: 'w_register_ready', width: 1, array_size: [total_registers]
      }
      wire :register_status, {
        name: 'w_register_status', width: 2, array_size: [total_registers]
      }
      wire :register_read_data, {
        name: 'w_register_read_data', width: bus_width, array_size: [total_registers]
      }
      wire :register_value, {
        name: 'w_register_value', width: value_width, array_size: [total_registers]
      }
    end

    private

    def total_registers
      register_block.files_and_registers.sum(&:count)
    end

    def address_width
      register_block.local_address_width
    end

    def bus_width
      configuration.bus_width
    end

    def value_width
      register_block.registers.map(&:width).max
    end
  end
end
