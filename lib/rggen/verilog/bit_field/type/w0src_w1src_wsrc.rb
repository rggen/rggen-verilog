# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0src, :w1src, :wsrc]) do
  verilog do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def set_value
      value = { w0src: 0b00, w1src: 0b01, wsrc: 0b10 }[bit_field.type]
      bin(value, 2)
    end
  end
end
