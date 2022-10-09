# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rol) do
  verilog do
    build do
      unless bit_field.reference?
        input :latch, {
          name: "i_#{full_name}_latch", width: 1, array_size: array_size
        }
      end
      input :value_in, {
        name: "i_#{full_name}", width: width, array_size: array_size
      }
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    def latch_signal
      reference_bit_field || latch[loop_variables]
    end
  end
end
