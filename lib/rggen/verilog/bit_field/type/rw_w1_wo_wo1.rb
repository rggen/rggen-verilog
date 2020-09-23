# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rw, :w1, :wo, :wo1]) do
  verilog do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width, array_size: array_size
      }
    end

    main_code :bit_field, from_template: true

    private

    def write_only
      bit_field.write_only? && 1 || 0
    end

    def write_once
      [:w1, :wo1].include?(bit_field.type) && 1 || 0
    end
  end
end
