# frozen_string_literal: true

RgGen.define_simple_feature(:register, :verilog_rtl_header) do
  verilog_rtl_header do
    build do
      define_macro("#{full_name}_byte_width", byte_width)
      define_macro("#{full_name}_byte_size", byte_size)
      define_array_macros if array?
      define_offset_address_macros
    end

    private

    def byte_width
      register.byte_width
    end

    def byte_size
      register.total_byte_size(hierarchical: true)
    end

    def array?
      register.array?(hierarchical: true)
    end

    def array_size
      register.array_size(hierarchical: true)
    end

    def define_array_macros
      size_list = array_size
      define_macro("#{full_name}_array_dimension", size_list.size)
      size_list.each_with_index do |size, i|
        define_macro("#{full_name}_array_size_#{i}", size)
      end
    end

    def define_offset_address_macros
      if array?
        address_list.zip(array_suffix) do |address, suffix|
          define_macro("#{full_name}_byte_offset_#{suffix}", address)
        end
      else
        define_macro("#{full_name}_byte_offset", address_list.first)
      end
    end

    def address_list
      width = register_block.local_address_width
      register
        .expanded_offset_addresses
        .map { |address| hex(address, width) }
    end

    def array_suffix
      array_size
        .map { |size| (0...size).to_a }
        .then { |list| list.first.product(*list[1..]) }
        .map { |list| list.join('_') }
    end
  end
end
