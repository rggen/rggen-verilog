# frozen_string_literal: true

RSpec.shared_context 'verilog common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_verilog_factory(builder)
    builder.build_factory(:output, :verilog)
  end

  def create_verilog(configuration = nil, &data_block)
    register_map = create_register_map(configuration) do
      register_block(&data_block)
    end
    @verilog_facotry[0] ||= build_verilog_factory(RgGen.builder)
    @verilog_facotry[0].create(configuration || default_configuration, register_map)
  end

  def delete_verilog_factory
    @verilog_facotry.clear
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
    @verilog_facotry ||= []
  end
end
