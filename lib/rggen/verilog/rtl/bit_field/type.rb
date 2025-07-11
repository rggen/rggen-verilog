# frozen_string_literal: true

RgGen.define_list_feature(:bit_field, :type) do
  verilog_rtl do
    base_feature do
      private

      def full_name
        bit_field.full_name('_')
      end

      def lsb
        bit_field.lsb(bit_field.local_index)
      end

      def width
        bit_field.width
      end

      def array_size
        bit_field.array_size
      end

      def initial_value
        if multiple_initial_values?
          index = bit_field.flat_loop_index
          total_bits = width * array_size.inject(:*)
          macro_call('rggen_slice', [bit_field.initial_value, total_bits, width, index])
        else
          bit_field.initial_value
        end
      end

      def multiple_initial_values?
        bit_field.initial_value_array? &&
          (array_size.size > 1 || array_size.first > 1)
      end

      def clock
        register_block.clock
      end

      def reset
        register_block.reset
      end

      def bit_field_read_valid
        register.bit_field_read_valid
      end

      def bit_field_write_valid
        register.bit_field_write_valid
      end

      def bit_field_mask
        register.bit_field_mask[lsb, width]
      end

      def bit_field_write_data
        register.bit_field_write_data[lsb, width]
      end

      def bit_field_read_data
        register.bit_field_read_data[lsb, width]
      end

      def bit_field_value
        register.bit_field_value[lsb, width]
      end

      def mask
        reference_bit_field || fill_1(width)
      end

      def reference_bit_field
        bit_field.reference? &&
          bit_field
            .find_reference(register_block.bit_fields)
            .value(bit_field.local_indexes, bit_field.reference_width)
      end

      def loop_variables
        bit_field.loop_variables
      end
    end

    factory do
      def target_feature_key(_configuration, bit_field)
        type = bit_field.type
        target_features.key?(type) && type ||
          (error "code generator for #{type} bit field type is not implemented")
      end
    end
  end
end
