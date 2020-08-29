# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in rggen-verilog.gemspec
gemspec

group :rggen do
  rggen_root = ENV['RGGEN_ROOT'] || File.expand_path('..', __dir__)
  gemfile_path = File.join(rggen_root, 'rggen-checkout', 'Gemfile')
  File.exist?(gemfile_path) && eval_gemfile(gemfile_path)

  if ENV['USE_FIXED_GEMS'] == 'yes'
    ['facets'].each do |library|
      library_path = File.expand_path("../#{library}", __dir__)
      if Dir.exist?(library_path) && !ENV['USE_GITHUB_REPOSITORY']
        gem library, path: library_path
      else
        gem library, git: "https://github.com/taichi-ishitani/#{library}.git"
      end
    end
  end
end

group :develop do
  gem 'rake'
  gem 'rubocop', '>= 0.80.1', require: false
end

group :test do
  gem 'regexp-examples', '~> 1.5.1', require: false
  gem 'rspec', '>= 3.8'
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
end
