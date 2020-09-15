# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  verilog do
    include RgGen::SystemVerilog::RTL::IndirectIndex

    build do
      wire :indirect_index, {
        name: 'w_indirect_index', width: index_width
      }
    end

    main_code :register do |code|
      code << indirect_index_assignment << nl
      code << process_template
    end
  end
end
