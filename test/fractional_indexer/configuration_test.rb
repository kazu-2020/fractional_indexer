# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  DIGITS_LIST = FractionalIndexer::Configuration::DIGITS_LIST

  def test_digits_defaults_to_base_62
    assert_equal(DIGITS_LIST[:base_62].to_a, FractionalIndexer::Configuration.new.digits)
  end

  { base_10: :base_10, base_94: :base_94, base_100: :base_62 }.each do |base, expected|
    define_method("test_digits_with_#{base}") do
      config = FractionalIndexer::Configuration.new
      config.base = base

      assert_equal(DIGITS_LIST[expected].to_a, config.digits)
    end
  end
end
