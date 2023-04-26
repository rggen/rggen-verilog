# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :verilog_rtl_header) do
  verilog_rtl_header do
    build do
      define_macro("#{full_name}_bit_width", width)
      define_macro("#{full_name}_bit_mask", mask)
      define_offset_macro
      define_label_macros
    end

    private

    def width
      bit_field.width
    end

    def mask
      hex((1 << width) - 1, width)
    end

    def define_offset_macro
      if bit_field.sequential?
        bit_field.sequence_size.times do |i|
          define_macro("#{full_name}_bit_offset_#{i}", bit_field.lsb(i))
        end
      else
        define_macro("#{full_name}_bit_offset", bit_field.lsb)
      end
    end

    def define_label_macros
      bit_field.labels.each do |label|
        name = "#{full_name}_#{label.name}"
        value = hex(label.value, bit_field.width)
        define_macro(name, value)
      end
    end
  end
end
