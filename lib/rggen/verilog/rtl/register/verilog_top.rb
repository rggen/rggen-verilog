# frozen_string_literal: true

RgGen.define_simple_feature(:register, :verilog_top) do
  verilog_rtl do
    include RgGen::SystemVerilog::RTL::RegisterIndex

    build do
      unless register.bit_fields.empty?
        wire :bit_field_read_valid, {
          name: 'w_bit_field_read_valid', width: 1
        }
        wire :bit_field_write_valid, {
          name: 'w_bit_field_write_valid', width: 1
        }
        wire :bit_field_mask, {
          name: 'w_bit_field_mask', width: register.width
        }
        wire :bit_field_write_data, {
          name: 'w_bit_field_write_data', width: register.width
        }
        wire :bit_field_read_data, {
          name: 'w_bit_field_read_data', width: register.width
        }
        wire :bit_field_value, {
          name: 'w_bit_field_value', width: register.width
        }
      end
    end

    main_code :register_file do
      local_scope("g_#{register.name}") do |scope|
        scope.top_scope top_scope?
        scope.loop_size loop_size
        scope.variables variables
        scope.body(&method(:body_code))
      end
    end

    private

    def top_scope?
      register_file.nil?
    end

    def loop_size
      (register.array? || nil) &&
        local_loop_variables.zip(register.array_size).to_h
    end

    def variables
      register.declarations[:variable]
    end

    def body_code(code)
      register.generate_code(code, :register, :top_down)
    end
  end
end
