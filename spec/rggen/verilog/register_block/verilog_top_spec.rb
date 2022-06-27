# frozen_string_literal: true

RSpec.describe 'register_block/verilog_top' do
  include_context 'verilog common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable_all
  end

  def create_register_block(&body)
    configuration = create_configuration(
      bus_width: 32, enable_wide_register: true
    )
    create_verilog(configuration, &body).register_blocks.first
  end

  let(:bus_width) { 32 }

  let(:address_width) { 8 }

  describe 'clock/reset' do
    it 'clock/resetを持つ' do
      register_block = create_register_block { name 'block_0'; byte_size 256 }
      expect(register_block).to have_port(
        :clock,
        name: 'i_clk', direction: :input, width: 1
      )
      expect(register_block).to have_port(
        :reset,
        name: 'i_rst_n', direction: :input, width: 1
      )
    end
  end

  describe 'レジスタアクセス' do
    def check_register_signals(register_block, array_size, value_width)
      expect(register_block).to have_wire(
        :register_valid,
        name: 'w_register_valid', width: 1
      )
      expect(register_block).to have_wire(
        :register_access,
        name: 'w_register_access', width: 2
      )
      expect(register_block).to have_wire(
        :register_address,
        name: 'w_register_address', width: address_width
      )
      expect(register_block).to have_wire(
        :register_write_data,
        name: 'w_register_write_data', width: bus_width
      )
      expect(register_block).to have_wire(
        :register_strobe,
        name: 'w_register_strobe', width: bus_width / 8
      )
      expect(register_block).to have_wire(
        :register_active,
        name: 'w_register_active', width: 1, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_ready,
        name: 'w_register_ready', width: 1, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_status,
        name: 'w_register_status', width: 2, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_read_data,
        name: 'w_register_read_data', width: bus_width, array_size: [array_size]
      )
      expect(register_block).to have_wire(
        :register_value,
        name: 'w_register_value', width: value_width, array_size: [array_size]
      )
    end

    it 'レジスタアクセス用の信号群を持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 1, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [2, 4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 8, bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
        register do
          name 'register_1'
          offset_address 0x10
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
        register do
          name 'register_2'
          offset_address 0x20
          bit_field { name 'bit_field_0'; bit_assignment lsb: 64; type :rw; initial_value 0 }
        end
      end
      check_register_signals(register_block, 3, 3 * bus_width)

      register_block = create_register_block do
        name 'block_0'
        byte_size 256

        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            end
            register do
              name 'register_1'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
            end
          end
        end
      end
      check_register_signals(register_block, 25, 2 * bus_width)
    end
  end

  describe '#write_file' do
    before do
      allow(FileUtils).to receive(:mkpath)
    end

    let(:configuration) do
      file = ['config.json', 'config.toml', 'config.yml'].sample
      path = File.join(RGGEN_SAMPLE_DIRECTORY, file)
      build_configuration_factory(RgGen.builder, false).create([path])
    end

    let(:register_map) do
      file_0 = ['block_0.rb', 'block_0.toml', 'block_0.yml'].sample
      file_1 = ['block_1.rb', 'block_1.toml', 'block_1.yml'].sample
      path = [file_0, file_1].map { |file| File.join(RGGEN_SAMPLE_DIRECTORY, file) }
      build_register_map_factory(RgGen.builder, false).create(configuration, path)
    end

    let(:register_blocks) do
      build_verilog_factory(RgGen.builder).create(configuration, register_map).register_blocks
    end

    let(:expected_code) do
      [
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_0.v'),
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_1.v')
      ].map { |path| File.binread(path) }
    end

    it 'RTLのソースコードを書きだす' do
      expect {
        register_blocks[0].write_file('foo')
      }.to write_file(match_string('foo/block_0.v'), expected_code[0])

      expect {
        register_blocks[1].write_file('bar')
      }.to write_file(match_string('bar/block_1.v'), expected_code[1])
    end
  end
end
