# frozen_string_literal: true

RSpec.describe RgGen::Verilog::RTL::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:components) do
    register_block = create_component(nil, :register_block)
    register = create_component(register_block, :register)
    bit_field = create_component(register, :bit_field)
    [register_block, register, bit_field]
  end

  let(:features) do
    components.map do |component|
      described_class.new(:foo, nil, component) { |f| component.add_feature(f) }
    end
  end

  def create_component(parent, layer)
    RgGen::Verilog::RTL::Component.new(parent, 'component', layer, configuration, register_map)
  end

  describe '#wire' do
    specify '既定の宣言追加先は自身の階層' do
      features[0].instance_eval { wire :foo }
      features[1].instance_eval { wire :bar, name: 'barbar', width: 2 }
      features[2].instance_eval { wire :baz, name: 'bazbaz', width: 3, array_size: [3, 2] }

      expect(components[0]).to have_declaration(:variable, 'wire foo')
      expect(components[1]).to have_declaration(:variable, 'wire [1:0] barbar')
      expect(components[2]).to have_declaration(:variable, 'wire [17:0] bazbaz')
    end

    specify 'array_formatの設定によらず、配列の形式はserializedになる' do
      features[0].instance_eval { wire :foo, width: 2, array_size: [2, 3], array_format: :unpacked }
      features[0].instance_eval { wire :bar, width: 2, array_size: [2, 3], array_format: :packed }

      expect(components[0]).to have_declaration(:variable, 'wire [11:0] foo')
      expect(components[0]).to have_declaration(:variable, 'wire [11:0] bar')
    end
  end

  describe '#input/#output' do
    specify 'data_typeは無視される' do
      features[0].instance_eval { input :foo, data_type: :logic }
      features[0].instance_eval { input :bar, data_type: :reg, width: 2 }
      features[0].instance_eval { output :baz, data_type: :logic }
      features[0].instance_eval { output :qux, data_type: :reg, width: 2 }

      expect(components[0]).to have_declaration(:port, 'input foo')
      expect(components[0]).to have_declaration(:port, 'input [1:0] bar')
      expect(components[0]).to have_declaration(:port, 'output baz')
      expect(components[0]).to have_declaration(:port, 'output [1:0] qux')
    end

    specify 'array_formatの設定によらず、配列の形式はserializedになる' do
      features[0].instance_eval { input :foo, width: 2, array_size: [2, 3], array_format: :unpacked }
      features[0].instance_eval { input :bar, width: 2, array_size: [2, 3], array_format: :packed }
      features[0].instance_eval { output :baz, width: 2, array_size: [2, 3], array_format: :unpacked }
      features[0].instance_eval { output :qux, width: 2, array_size: [2, 3], array_format: :packed }

      expect(components[0]).to have_declaration(:port, 'input [11:0] foo')
      expect(components[0]).to have_declaration(:port, 'input [11:0] bar')
      expect(components[0]).to have_declaration(:port, 'output [11:0] baz')
      expect(components[0]).to have_declaration(:port, 'output [11:0] qux')
    end
  end

  describe '#parameter' do
    specify 'array_formatの設定によらず、配列の形式はserializedになる' do
      features[0].instance_eval { parameter :foo, width: 2, array_size: [2, 3], array_format: :unpacked }
      features[0].instance_eval { parameter :bar, width: 2, array_size: [2, 3], array_format: :packed }

      expect(components[0]).to have_declaration(:parameter, 'parameter [11:0] foo')
      expect(components[0]).to have_declaration(:parameter, 'parameter [11:0] bar')
    end
  end
end
