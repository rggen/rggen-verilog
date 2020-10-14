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

    write_file '<%= register_block.name %>.v' do |file|
      file.body(&method(:body_code))
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

    def body_code(code)
      macro_definition(code)
      verilog_module_definition(code)
    end

    def macro_definition(code)
      template_path = File.join(__dir__, 'verilog_macros.erb')
      code << process_template(template_path)
    end

    def verilog_module_definition(code)
      code << module_definition(register_block.name) do |verilog_module|
        verilog_module.parameters parameters
        verilog_module.ports ports
        verilog_module.variables variables
        verilog_module.body(&method(:verilog_module_body))
      end
    end

    def parameters
      register_block.declarations[:parameter]
    end

    def ports
      register_block.declarations[:port]
    end

    def variables
      register_block.declarations[:variable]
    end

    def verilog_module_body(code)
      { register_block: nil, register_file: 1 }.each do |kind, depth|
        register_block.generate_code(code, kind, :top_down, depth)
      end
    end
  end
end
