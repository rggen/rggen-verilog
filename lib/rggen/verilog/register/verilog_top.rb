# frozen_string_literal: true

RgGen.define_simple_feature(:register, :verilog_top) do
  verilog do
    build do
      unless register.bit_fields.empty?
        wire :bit_field_valid, {
          name: 'w_bit_field_valid', width: 1
        }
        wire :bit_field_read_mask, {
          name: 'w_bit_field_read_mask', width: register.width
        }
        wire :bit_field_write_mask, {
          name: 'w_bit_field_write_mask', width: register.width
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
  end
end
