# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rc, :w0c, :w1c, :wc, :woc]) do
  verilog_rtl do
    build do
      input :set, {
        name: "i_#{full_name}_set", width:, array_size:
      }
      output :value_out, {
        name: "o_#{full_name}", width:, array_size:
      }
      if bit_field.reference?
        output :value_unmasked, {
          name: "o_#{full_name}_unmasked", width:, array_size:
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def read_action
      {
        rc: '`RGGEN_READ_CLEAR',
        w0c: '`RGGEN_READ_DEFAULT',
        w1c: '`RGGEN_READ_DEFAULT',
        wc: '`RGGEN_READ_DEFAULT',
        woc: '`RGGEN_READ_NONE'
      }[bit_field.type]
    end

    def write_action
      {
        rc: '`RGGEN_WRITE_NONE',
        w0c: '`RGGEN_WRITE_0_CLEAR',
        w1c: '`RGGEN_WRITE_1_CLEAR',
        wc: '`RGGEN_WRITE_CLEAR',
        woc: '`RGGEN_WRITE_CLEAR'
      }[bit_field.type]
    end

    def external_mask
      bit_field.reference? && bin(1, 1) || bin(0, 1)
    end

    def value_out_unmasked
      (bit_field.reference? || nil) && value_unmasked[loop_variables]
    end
  end
end
