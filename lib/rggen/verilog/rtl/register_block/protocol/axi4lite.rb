# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :axi4lite) do
  verilog_rtl do
    build do
      parameter :id_width, {
        name: 'ID_WIDTH', default: 0
      }
      parameter :write_first, {
        name: 'WRITE_FIRST', default: 1
      }

      input :awvalid, {
        name: 'i_awvalid', width: 1
      }
      output :awready, {
        name: 'o_awready', width: 1
      }
      input :awid, {
        name: 'i_awid', width: macro_call(:rggen_clip_width, id_width)
      }
      input :awaddr, {
        name: 'i_awaddr', width: address_width
      }
      input :awprot, {
        name: 'i_awprot', width: 3
      }
      input :wvalid, {
        name: 'i_wvalid', width: 1
      }
      output :wready, {
        name: 'o_wready', width: 1
      }
      input :wdata, {
        name: 'i_wdata', width: bus_width
      }
      input :wstrb, {
        name: 'i_wstrb', width: bus_width / 8
      }
      output :bvalid, {
        name: 'o_bvalid', width: 1
      }
      input :bready, {
        name: 'i_bready', width: 1
      }
      output :bid, {
        name: 'o_bid', width: macro_call(:rggen_clip_width, id_width)
      }
      output :bresp, {
        name: 'o_bresp', width: 2
      }
      input :arvalid, {
        name: 'i_arvalid', width: 1
      }
      output :arready, {
        name: 'o_arready', width: 1
      }
      input :arid, {
        name: 'i_arid', width: macro_call(:rggen_clip_width, id_width)
      }
      input :araddr, {
        name: 'i_araddr', width: address_width
      }
      input :arprot, {
        name: 'i_arprot', width: 3
      }
      output :rvalid, {
        name: 'o_rvalid', width: 1
      }
      input :rready, {
        name: 'i_rready', width: 1
      }
      output :rid, {
        name: 'o_rid', width: macro_call(:rggen_clip_width, id_width)
      }
      output :rdata, {
        name: 'o_rdata', width: bus_width
      }
      output :rresp, {
        name: 'o_rresp', width: 2
      }
    end

    main_code :register_block, from_template: true
  end
end
