# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter if ENV["CI"]
SimpleCov.start { add_filter "/test/" }

require "fractional_indexer"
require "minitest/autorun"

module TestSupport
  def use_base(base)
    FractionalIndexer.configure { |config| config.base = base }
  end

  def teardown
    use_base(:base_62)
    super
  end
end

Minitest::Test.include(TestSupport)
