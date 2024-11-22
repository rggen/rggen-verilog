# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  verilog_rtl do
    include RgGen::SystemVerilog::RTL::IndirectIndex

    build do
      wire :indirect_match, {
        name: 'w_indirect_match', width: index_match_width
      }
    end

    main_code :register do |code|
      indirect_index_matches(code)
      code << process_template
    end

    private

    def array_index_value(value, width)
      value[0, width]
    end
  end
end
