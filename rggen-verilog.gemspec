# frozen_string_literal: true

require File.expand_path('lib/rggen/verilog/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-verilog'
  spec.version = RgGen::Verilog::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-verilog-#{RgGen::Verilog::VERSION}"
  spec.description = 'Verilog write plugin for RgGen'
  spec.homepage = 'https://github.com/rggen/rggen-verilog'
  spec.license = 'MIT'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rggen/rggen/issues',
    'mailing_list_uri' => 'https://groups.google.com/d/forum/rggen',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rggen/rggen-verilog',
    'wiki_uri' => 'https://github.com/rggen/rggen/wiki'
  }

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.add_runtime_dependency 'rggen-systemverilog', '>= 0.33.0'
end
