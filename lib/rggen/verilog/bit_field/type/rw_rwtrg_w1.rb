# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rw, :rwtrg, :w1]) do
  verilog do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
      if rwtrg?
        output :write_trigger, {
          name: "o_#{full_name}_write_trigger", width: 1, array_size: array_size
        }
        output :read_trigger, {
          name: "o_#{full_name}_read_trigger", width: 1, array_size: array_size
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def rwtrg?
      bit_field.type == :rwtrg
    end

    def write_once
      bit_field.type == :w1 && 1 || 0
    end

    def trigger
      rwtrg? && 1 || 0
    end

    def write_trigger_signal
      rwtrg? && write_trigger[loop_variables] || nil
    end

    def read_trigger_signal
      rwtrg? && read_trigger[loop_variables] || nil
    end
  end
end
