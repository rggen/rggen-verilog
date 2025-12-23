# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :counter) do
  verilog_rtl do
    build do
      parameter :up_width, {
        name: "#{full_name}_up_width".upcase, default: 1
      }
      parameter :up_port_width, {
        name: "#{full_name}_up_port_width".upcase,
        default: macro_call(:rggen_clip_width, up_width)
      }
      parameter :down_width, {
        name: "#{full_name}_down_width".upcase, default: 1
      }
      parameter :down_port_width, {
        name: "#{full_name}_down_port_width".upcase,
        default: macro_call(:rggen_clip_width, down_width)
      }
      parameter :wrap_around, {
        name: "#{full_name}_wrap_around".upcase, default: 0
      }
      if external_clear?
        parameter :use_clear, {
          name: "#{full_name}_use_clear".upcase, default: 1
        }
      end

      input :up, {
        name: "i_#{full_name}_up",
        width: up_port_width, array_size:
      }
      input :down, {
        name: "i_#{full_name}_down",
        width: down_port_width, array_size:
      }
      if external_clear?
        input :clear, {
          name: "i_#{full_name}_clear", width: 1, array_size:
        }
      end
      output :count, {
        name: "o_#{full_name}", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def external_clear?
      !bit_field.reference?
    end

    def use_clear_value
      external_clear? && use_clear || 1
    end

    def clear_signal
      reference_bit_field || clear[loop_variables]
    end
  end
end
