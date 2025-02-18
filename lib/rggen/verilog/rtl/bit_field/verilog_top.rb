# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :verilog_top) do
  verilog_rtl do
    include RgGen::SystemVerilog::RTL::BitFieldIndex

    export :initial_value
    export :value

    build do
      if parameterized_initial_value?
        parameter :initial_value, {
          name: initial_value_name, width: bit_field.width,
          array_size: initial_value_size, default: initial_value_rhs
        }
      else
        define_accessor_for_initial_value
      end
    end

    main_code :register do
      local_scope("g_#{bit_field.name}") do |scope|
        scope.loop_size loop_size
        scope.body(&method(:body_code))
      end
    end

    def value(offsets = nil, width = nil)
      value_lsb = bit_field.lsb(offsets&.last || local_index)
      value_width = width || bit_field.width
      register_value(offsets&.slice(0..-2), value_lsb, value_width)
    end

    private

    def register_value(offsets, lsb, width)
      index = register.index(offsets || register.local_indexes)
      register_block.register_value[[index], lsb, width]
    end

    def parameterized_initial_value?
      bit_field.initial_value? && !bit_field.fixed_initial_value?
    end

    def define_accessor_for_initial_value
      define_singleton_method(:initial_value) do
        bit_field.initial_value? && initial_value_rhs || nil
      end
    end

    def initial_value_name
      "#{bit_field.full_name('_')}_initial_value".upcase
    end

    def initial_value_size
      bit_field.initial_value_array? && array_size || nil
    end

    def initial_value_rhs
      if !bit_field.initial_value_array?
        sized_initial_value
      elsif bit_field.fixed_initial_value?
        merged_initial_values
      else
        size = array_size.inject(:*)
        repeat(size, sized_initial_value)
      end
    end

    def sized_initial_value
      hex(bit_field.register_map.initial_value, bit_field.width)
    end

    def merged_initial_values
      initial_values = bit_field.initial_values(flatten: true)
      merged_value =
        initial_values
          .map.with_index { |v, i| v << (i * bit_field.width) }
          .inject(:|)
      hex(merged_value, bit_field.width * initial_values.size)
    end

    def loop_size
      loop_variable = local_index
      loop_variable && { loop_variable => bit_field.sequence_size }
    end

    def body_code(code)
      bit_field.generate_code(code, :bit_field, :top_down)
    end
  end
end
