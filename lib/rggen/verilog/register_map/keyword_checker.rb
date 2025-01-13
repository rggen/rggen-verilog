# frozen_string_literal: true

module RgGen
  module Verilog
    module RegisterMap
      module KeywordChecker
        VERILOG_KEYWORDS = [
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
          'realtime', 'reg', 'release', 'repeat', 'rnmos', 'rpmos', 'rtran', 'rtranif0',
          'rtranif1', 'scalared', 'showcancelled', 'signed', 'small', 'specify',
          'specparam', 'strong0', 'strong1', 'supply0', 'supply1', 'table', 'task',
          'time', 'tran', 'tranif0', 'tranif1', 'tri', 'tri0', 'tri1', 'triand', 'trior',
          'trireg', 'unsigned', 'use', 'uwire', 'vectored', 'wait', 'wand', 'weak0',
          'weak1', 'while', 'wire', 'wor', 'xnor', 'xor'
        ].freeze

        def self.included(klass)
          klass.class_eval do
            verify(:feature, prepend: true) do
              error_condition do
                @name && VERILOG_KEYWORDS.include?(@name)
              end
              message do
                layer_name = component.layer.to_s.sub('_', ' ')
                "verilog keyword is not allowed for #{layer_name} name: #{@name}"
              end
            end
          end
        end
      end
    end
  end
end
