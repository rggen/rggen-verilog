# frozen_string_literal: true

RSpec.describe 'regiter_map/name' do
  include_context 'clean-up builder'
  include_context 'register map common'

  before(:all) do
    RgGen.enable(:register_block, :name)
    RgGen.enable(:register_file, :name)
    RgGen.enable(:register, :name)
    RgGen.enable(:bit_field, :name)
  end

  let(:verilog_keywords) do
    [
      'always', 'and', 'assign', 'automatic', 'begin', 'buf', 'bufif0', 'bufif1',
      'case', 'casex', 'casez', 'cell', 'cmos', 'config', 'deassign', 'default',
      'defparam', 'design', 'disable', 'edge', 'else', 'end', 'endcase', 'endconfig',
      'endfunction', 'endgenerate', 'endmodule', 'endprimitive', 'endspecify',
      'endtable', 'endtask', 'event', 'for', 'force', 'forever', 'fork', 'function',
      'generate', 'genvar', 'highz0', 'highz1', 'if', 'ifnone', 'incdir', 'include',
      'initial', 'inout', 'input', 'instance', 'integer', 'join', 'large', 'liblist',
      'library', 'localparam', 'macromodule', 'medium', 'module', 'nand', 'negedge',
      'nmos', 'nor', 'noshowcancelled', 'not', 'notif0', 'notif1', 'or', 'output',
      'parameter', 'pmos', 'posedge', 'primitive', 'pull0', 'pull1', 'pulldown',
      'pullup', 'pulsestyle_onevent', 'pulsestyle_ondetect', 'rcmos', 'real',
      'realtime', 'reg', 'release', 'repeat', 'rnmos', 'rpmos', 'rtran',
      'rtranif0', 'rtranif1', 'scalared', 'showcancelled', 'signed', 'small',
      'specify', 'specparam', 'strong0', 'strong1', 'supply0', 'supply1',
      'table', 'task', 'time', 'tran', 'tranif0', 'tranif1', 'tri', 'tri0',
      'tri1', 'triand', 'trior', 'trireg', 'unsigned', 'use', 'uwire', 'vectored',
      'wait', 'wand', 'weak0', 'weak1', 'while', 'wire', 'wor', 'xnor', 'xor'
    ]
  end

  context 'レジスタブロック名がVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      verilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block { name keyword }
          end
        }.to raise_register_map_error "verilog keyword is not allowed for register block name: #{keyword}"
      end
    end
  end

  context 'レジスタファイル名がVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      verilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register_file { name keyword }
            end
          end
        }.to raise_register_map_error "verilog keyword is not allowed for register file name: #{keyword}"
      end
    end
  end

  context 'レジスタ名がVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      verilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register { name keyword }
            end
          end
        }.to raise_register_map_error "verilog keyword is not allowed for register name: #{keyword}"
      end
    end
  end

  context 'ビットフィールド名がVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      verilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register do
                name 'register_0'
                bit_field { name keyword }
              end
            end
          end
        }.to raise_register_map_error "verilog keyword is not allowed for bit field name: #{keyword}"
      end
    end
  end
end
