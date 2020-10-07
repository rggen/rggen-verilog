# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0trg, :w1trg]) do
  verilog do
    build do
      output :trigger, {
        name: "o_#{full_name}_trigger", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def trigger_value
      bin({ w0trg: 0, w1trg: 1 }[bit_field.type], 1)
    end
  end
end
