# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:row0trg, :row1trg]) do
  verilog_rtl do
    build do
      unless bit_field.reference?
        input :value_in, {
          name: "i_#{full_name}", width:, array_size:
        }
      end
      output :trigger, {
        name: "o_#{full_name}_trigger", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def trigger_value
      bin({ row0trg: 0, row1trg: 1 }[bit_field.type], 1)
    end

    def reference_or_value_in
      reference_bit_field || value_in[loop_variables]
    end
  end
end
