# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :avalon) do
  verilog_rtl do
    build do
      input :read, {
        name: 'i_read', width: 1
      }
      input :write, {
        name: 'i_write', width: 1
      }
      input :address, {
        name: 'i_address', width: address_width
      }
      input :byteenable, {
        name: 'i_byteenable', width: bus_width / 8
      }
      input :writedata, {
        name: 'i_writedata', width: bus_width
      }
      output :waitrequest, {
        name: 'o_waitrequest', width: 1
      }
      output :readdatavalid, {
        name: 'o_readdatavalid', width: 1
      }
      output :writeresponsevalid, {
        name: 'o_writeresponsevalid', width: 1
      }
      output :response, {
        name: 'o_response', width: 2
      }
      output :readdata, {
        name: 'o_readdata', width: bus_width
      }
    end

    main_code :register_block, from_template: true
  end
end
