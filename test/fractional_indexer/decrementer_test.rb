# frozen_string_literal: true

require "test_helper"

class DecrementerTest < Minitest::Test
  {
    [:base_10, "a1"] => "a0",
    [:base_10, "a0"] => "Z9",
    [:base_10, "b00"] => "a9",
    [:base_10, "Z0"] => "Y99",
    [:base_10, "A" + "0" * 26] => nil,
    [:base_62, "b00"] => "az",
    [:base_62, "b10"] => "b0z",
    [:base_62, "c000"] => "bzz",
    [:base_62, "Zz"] => "Zy",
    [:base_62, "a0"] => "Zz",
    [:base_62, "Yzz"] => "Yzy",
    [:base_62, "Y00"] => "Xzzz",
    [:base_62, "dAC00"] => "dABzz",
    [:base_62, "A" + "0" * 26] => nil,
  }.each do |(base, key), expected|
    define_method("test_execute_#{base}_#{key}") do
      use_base(base)
      result = FractionalIndexer::Decrementer.execute(FractionalIndexer::OrderKey.new(key))

      expected.nil? ? assert_nil(result) : assert_equal(expected, result)
    end
  end
end
