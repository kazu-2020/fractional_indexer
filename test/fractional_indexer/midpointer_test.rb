# frozen_string_literal: true

require "test_helper"

class MidpointerTest < Minitest::Test
  {
    [:base_10, nil, nil] => "5",
    [:base_10, "", ""] => "5",
    [:base_10, nil, ""] => "5",
    [:base_10, "", nil] => "5",
    [:base_10, "5", nil] => "8",
    [:base_10, "8", nil] => "9",
    [:base_10, "9", nil] => "95",
    [:base_10, "95", nil] => "98",
    [:base_10, "98", nil] => "99",
    [:base_10, "99", nil] => "995",
    [:base_10, nil, "5"] => "3",
    [:base_10, nil, "3"] => "2",
    [:base_10, nil, "2"] => "1",
    [:base_10, nil, "1"] => "05",
    [:base_10, nil, "05"] => "03",
    [:base_10, "1", "2"] => "15",
    [:base_10, "05", "1"] => "08",
    [:base_10, "499", "5"] => "4995",
    [:base_10, "001", "001002"] => "001001",
    [:base_10, "001", "001001"] => "0010005",
    [:base_62, nil, nil] => "V",
    [:base_62, "V", nil] => "l",
    [:base_62, "l", nil] => "t",
    [:base_62, "z", nil] => "zV",
    [:base_62, "zV", nil] => "zl",
    [:base_62, "zz", nil] => "zzV",
    [:base_62, nil, "V"] => "G",
    [:base_62, nil, "G"] => "8",
    [:base_62, nil, "1"] => "0V",
    [:base_62, "1", "2"] => "1V",
    [:base_62, "001", "001001"] => "001000V",
    [:base_62, "4zz", "5"] => "4zzV",
  }.each do |(base, prev_pos, next_pos), expected|
    define_method("test_execute_#{base}_between_#{prev_pos.inspect}_and_#{next_pos.inspect}") do
      use_base(base)

      assert_equal(expected, FractionalIndexer::Midpointer.execute(prev_pos, next_pos))
    end
  end

  {
    ["1", "0"] => "prev_pos must be less than next_pos",
    ["1", "20"] => "prev_pos and next_pos cannot end with 0",
    ["10", "2"] => "prev_pos and next_pos cannot end with 0",
  }.each do |(prev_pos, next_pos), message|
    define_method("test_execute_base_10_raises_between_#{prev_pos.inspect}_and_#{next_pos.inspect}") do
      use_base(:base_10)
      error = assert_raises(FractionalIndexer::Error) { FractionalIndexer::Midpointer.execute(prev_pos, next_pos) }

      assert_equal(message, error.message)
    end
  end
end
