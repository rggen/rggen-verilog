# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :native) do
  verilog_rtl do
    build do
      parameter :strobe_width, {
        name: 'STROBE_WIDTH', default: bus_width / 8
      }
      parameter :use_read_strobe, {
        name: 'USE_READ_STROBE', default: 0
      }

      input :valid, {
        name: 'i_csrbus_valid', width: 1
      }
      input :access, {
        name: 'i_csrbus_access', width: 2
      }
      input :address, {
        name: 'i_csrbus_address', width: address_width
      }
      input :write_data, {
        name: 'i_csrbus_write_data', width: bus_width
      }
      input :strobe, {
        name: 'i_csrbus_strobe', width: strobe_width
      }
      output :ready, {
        name: 'o_csrbus_ready', width: 1
      }
      output :status, {
        name: 'o_csrbus_status', width: 2
      }
      output :read_data, {
        name: 'o_csrbus_read_data', width: bus_width
      }
    end

    main_code :register_block, from_template: true
  end
end
