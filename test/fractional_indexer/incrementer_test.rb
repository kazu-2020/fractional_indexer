# frozen_string_literal: true

require "test_helper"

class IncrementerTest < Minitest::Test
  {
    [:base_10, "a0"] => "a1",
    [:base_10, "a1"] => "a2",
    [:base_10, "c999"] => "d0000",
    [:base_10, "Z999"] => "a0",
    [:base_10, "Y99"] => "Z0",
    [:base_10, "z" + "9" * 26] => nil,
    [:base_62, "az"] => "b00",
    [:base_62, "a9"] => "aA",
    [:base_62, "b0z"] => "b10",
    [:base_62, "bzz"] => "c000",
    [:base_62, "Zy"] => "Zz",
    [:base_62, "Yzy"] => "Yzz",
    [:base_62, "dABzz"] => "dAC00",
    [:base_62, "z" * 27] => nil,
  }.each do |(base, key), expected|
    define_method("test_execute_#{base}_#{key}") do
      use_base(base)
      result = FractionalIndexer::Incrementer.execute(FractionalIndexer::OrderKey.new(key))

      expected.nil? ? assert_nil(result) : assert_equal(expected, result)
    end
  end
end
