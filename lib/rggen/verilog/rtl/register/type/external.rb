# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :external) do
  verilog_rtl do
    build do
      output :external_valid, {
        name: "o_#{register.name}_valid", width: 1
      }
      output :external_access, {
        name: "o_#{register.name}_access", width: 2
      }
      output :external_address, {
        name: "o_#{register.name}_address", width: address_width
      }
      output :external_write_data, {
        name: "o_#{register.name}_data", width: bus_width
      }
      output :external_strobe, {
        name: "o_#{register.name}_strobe", width: bus_width / 8
      }
      input :external_ready, {
        name: "i_#{register.name}_ready", width: 1
      }
      input :external_status, {
        name: "i_#{register.name}_status", width: 2
      }
      input :external_read_data, {
        name: "i_#{register.name}_data", width: bus_width
      }
    end

    main_code :register, from_template: true

    private

    def start_address
      hex(register.offset_address, address_width)
    end

    def end_address
      address = register.offset_address + register.byte_size - 1
      hex(address, address_width)
    end
  end
end
