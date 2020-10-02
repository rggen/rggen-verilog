# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rwe) do
  verilog do
    build do
      unless bit_field.reference?
        input :enable, {
          name: "i_#{full_name}_enable", width: 1, array_size: array_size
        }
      end
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def enable_signal
      reference_bit_field || enable[loop_variables]
    end
  end
end
