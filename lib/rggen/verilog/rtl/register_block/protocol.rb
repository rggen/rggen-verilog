# frozen_string_literal: true

RgGen.define_list_feature(:register_block, :protocol) do
  verilog_rtl do
    shared_context.feature_registry(registry)

    base_feature do
      build do
        parameter :address_width, {
          name: 'ADDRESS_WIDTH', default: local_address_width
        }
        parameter :pre_decode, {
          name: 'PRE_DECODE', default: 0
        }
        parameter :base_address, {
          name: 'BASE_ADDRESS', width: address_width, default: 0
        }
        parameter :error_status, {
          name: 'ERROR_STATUS', default: 0
        }
        parameter :default_read_data, {
          name: 'DEFAULT_READ_DATA', width: bus_width, default: 0
        }
        parameter :insert_slicer, {
          name: 'INSERT_SLICER', default: 0
        }
      end

      private

      def bus_width
        register_block.bus_width
      end

      def local_address_width
        register_block.local_address_width
      end

      def total_registers
        register_block.files_and_registers.sum(&:count)
      end

      def byte_size
        register_block.byte_size
      end
    end

    factory do
      def target_feature_key(_configuration, register_block)
        register_block.protocol
      end
    end
  end
end
