# frozen_string_literal: true

RSpec.describe 'register/type' do
  include_context 'clean-up builder'
  include_context 'verilog common'

  before(:all) do
    RgGen.enable(:register, :type)
    RgGen.enable(:register, :type, [:foo, :bar])
  end

  context 'コード生成が実装されていないレジスタ型が指定された場合' do
    before(:all) do
      RgGen.define_list_item_feature(:register, :type, :foo) do
        register_map { no_bit_fields }
        verilog {}
      end
      RgGen.define_list_item_feature(:register, :type, :bar) do
        register_map { no_bit_fields }
      end
    end

    after(:all) do
      delete_register_map_factory
      delete_verilog_factory
      RgGen.delete(:register, :type, [:foo, :bar])
    end

    it 'GeneratorErrorを起こす' do
      expect {
        create_verilog do
          register_block { register { bit_field } }
        end
      }.not_to raise_error

      expect {
        create_verilog do
          register_block { register { type :foo } }
        end
      }.not_to raise_error

      expect {
        create_verilog do
          register_block { register { type :bar } }
        end
      }.to raise_error RgGen::Core::GeneratorError, 'code generator for bar register type is not implemented'
    end
  end
end
