# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:wo, :wo1, :wotrg]) do
  verilog_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", width:, array_size:
      }
      if wotrg?
        output :write_trigger, {
          name: "o_#{full_name}_write_trigger", width: 1, array_size:
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def wotrg?
      bit_field.type == :wotrg
    end

    def write_once
      bit_field.type == :wo1 && 1 || 0
    end

    def trigger
      wotrg? && 1 || 0
    end

    def write_trigger_signal
      wotrg? && write_trigger[loop_variables] || nil
    end
  end
end
