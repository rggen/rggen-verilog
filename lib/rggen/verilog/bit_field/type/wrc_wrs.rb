# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:wrc, :wrs]) do
  verilog do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true
  end
end
