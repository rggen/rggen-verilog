# frozen_string_literal: true

RSpec.shared_context 'verilog rtl common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_verilog_rtl_factory(builder)
    builder.build_factory(:output, :verilog_rtl)
  end

  def create_verilog_rtl(configuration = nil, &data_block)
    register_map = create_register_map(configuration) do
      register_block(&data_block)
    end
    @verilog_rtl_facotry[0] ||= build_verilog_rtl_factory(RgGen.builder)
    @verilog_rtl_facotry[0].create(configuration || default_configuration, register_map)
  end

  def delete_verilog_rtl_factory
    @verilog_rtl_facotry.clear
  end

  def have_port(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    attributes = attributes.merge(array_format: :serialized)
    port = RgGen::SystemVerilog::Common::Utility::DataObject.new(:argument, **attributes, &body)
    have_declaration(layer, :port, port.declaration).and have_identifier(handler, port.identifier)
  end

  def not_have_port(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    attributes = attributes.merge(array_format: :serialized)
    port = RgGen::SystemVerilog::Common::Utility::DataObject.new(:argument, **attributes, &body)
    not_have_declaration(layer, :port, port.declaration).and not_have_identifier(handler)
  end

  def have_wire(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    attributes = attributes.merge(data_type: :wire, array_format: :serialized)
    wire = RgGen::SystemVerilog::Common::Utility::DataObject.new(:variable, **attributes, &body)
    have_declaration(layer, :variable, wire.declaration).and have_identifier(handler, wire.identifier)
  end

  def not_have_wire(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    attributes = attributes.merge(data_type: :wire, array_format: :serialized)
    wire = RgGen::SystemVerilog::Common::Utility::DataObject.new(:variable, **attributes, &body)
    not_have_declaration(layer, :variable, wire.declaration).and not_have_identifier(handler, wire.identifier)
  end

  def have_parameter(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
      attributes = attributes.merge(array_format: :serialized)
    parameter = RgGen::SystemVerilog::Common::Utility::DataObject.new(:parameter, **attributes, &body)
    have_declaration(layer, :parameter, parameter.declaration).and have_identifier(handler, parameter.identifier)
  end

  before(:all) do
    @verilog_rtl_facotry ||= []
  end
end

RSpec.shared_context 'bit field verilog common' do
  include_context 'verilog rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:register_block, :verilog_top)
    RgGen.enable(:register_file, :verilog_top)
    RgGen.enable(:register, :verilog_top)
    RgGen.enable(:bit_field, :verilog_top)
  end

  def create_bit_fields(&body)
    configuration = create_configuration(enable_wide_register: true)
    create_verilog_rtl(configuration, &body).bit_fields
  end
end

RSpec.shared_context 'verilog rtl header common' do
  include_context 'verilog rtl common'

  def build_verilog_rtl_header_factory(builder)
    builder.build_factory(:output, :verilog_rtl_header)
  end

  def create_verilog_rtl_header(configuration = nil, &data_block)
    configuration = default_configuration if configuration.nil?
    register_map = create_register_map(configuration) { register_block(&data_block) }
    @verilog_rtl_header_factory[0] ||= build_verilog_rtl_header_factory(RgGen.builder)
    @verilog_rtl_header_factory[0].create(configuration, register_map)
  end

  def delete_verilog_rtl_header_factory
    @verilog_rtl_header_factory.delete
  end

  before(:all) do
    @verilog_rtl_header_factory ||= []
  end
end
