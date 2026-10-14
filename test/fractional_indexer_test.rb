# frozen_string_literal: true

require "test_helper"

class FractionalIndexerTest < Minitest::Test
  {
    [nil, nil] => "a0",
    [nil, "a0"] => "Zz",
    ["a0", nil] => "a1",
    ["a0", "a1"] => "a0V",
    ["a0V", "a1"] => "a0l",
    ["Zz", "a0"] => "ZzV",
    ["Zz", "a1"] => "a0",
    [nil, "Y00"] => "Xzzz",
    ["bzz", nil] => "c000",
    ["a0", "a0V"] => "a0G",
    ["a0", "a0G"] => "a08",
    ["b125", "b129"] => "b127",
    ["a0", "a1V"] => "a1",
    ["Zz", "a01"] => "a0",
    [nil, "a0V"] => "a0",
    [nil, "b999"] => "b99",
    [nil, "A00000000000000000000000001"] => "A00000000000000000000000000V",
    [nil, "A000000000000000000000000001"] => "A000000000000000000000000000V",
    ["z" * 26 + "y", nil] => "z" * 27,
    ["z" * 27, nil] => "z" * 27 + "V",
  }.each do |(prev_key, next_key), expected|
    define_method("test_generate_key_between_#{prev_key.inspect}_and_#{next_key.inspect}") do
      assert_equal(expected, FractionalIndexer.generate_key(prev_key: prev_key, next_key: next_key))
    end
  end

  {
    ["a0", "Z9"] => "a0 is not less than Z9",
    ["", "a0"] => "prev_key and next_key cannot be empty",
    ["a0", ""] => "prev_key and next_key cannot be empty",
    [nil, "A" + "0" * 25] => nil,
    [nil, "A" + "0" * 26] => nil,
    ["a00", nil] => nil,
    ["a00", "a1"] => nil,
    ["0", "1"] => nil,
  }.each do |(prev_key, next_key), message|
    define_method("test_generate_key_raises_between_#{prev_key.inspect}_and_#{next_key.inspect}") do
      error = assert_raises(FractionalIndexer::Error) do
        FractionalIndexer.generate_key(prev_key: prev_key, next_key: next_key)
      end
      assert_equal(message, error.message) if message
    end
  end

  {
    ["a0", nil, 0] => [],
    ["a0", nil, -1] => [],
    [nil, nil, 5] => ["a0", "a1", "a2", "a3", "a4"],
    ["a41", nil, 5] => ["a5", "a6", "a7", "a8", "a9"],
    [nil, "a1", 2] => ["Z9", "a0"],
    ["a0", "a2", 20] => [
      "a01",
      "a02",
      "a03",
      "a035",
      "a04",
      "a05",
      "a06",
      "a07",
      "a08",
      "a09",
      "a1",
      "a11",
      "a12",
      "a13",
      "a14",
      "a15",
      "a16",
      "a17",
      "a18",
      "a19",
    ],
    [nil, "A00000000000000000000000001", 5] => [
      "A0000000000000000000000000005",
      "A000000000000000000000000001",
      "A000000000000000000000000002",
      "A000000000000000000000000003",
      "A000000000000000000000000005",
    ],
  }.each do |(prev_key, next_key, count), expected|
    define_method("test_generate_keys_base_10_between_#{prev_key.inspect}_and_#{next_key.inspect}_count_#{count}") do
      use_base(:base_10)

      assert_equal(expected, FractionalIndexer.generate_keys(prev_key: prev_key, next_key: next_key, count: count))
    end
  end
end
