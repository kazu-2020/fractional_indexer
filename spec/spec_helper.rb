# frozen_string_literal: true

require "bundler/setup"
require "fractional_indexer"
require "simplecov"
require "simplecov-cobertura"

if ENV["CI"]
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
SimpleCov.start

# Previous content of test helper now starts here

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after do
    FractionalIndexer.configure do |config|
      config.base = :base_62
    end
  end
end
