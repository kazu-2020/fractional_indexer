# frozen_string_literal: true

require "test_helper"

class OrderKeyTest < Minitest::Test
  OrderKey = FractionalIndexer::OrderKey

  def test_negative_and_positive_raise_for_nil
    assert_raises(NoMethodError) { OrderKey.negative?(nil) }
    assert_raises(NoMethodError) { OrderKey.positive?(nil) }
  end

  { "" => [false, false], "Z0" => [true, false], "a0" => [false, true] }.each do |key, (negative, positive)|
    define_method("test_sign_of_#{key.inspect}") do
      assert_equal(negative, OrderKey.negative?(key))
      assert_equal(positive, OrderKey.positive?(key))
    end
  end

  { base_10: "a0", base_62: "a0", base_94: "a!" }.each do |base, expected|
    define_method("test_zero_with_#{base}") do
      use_base(base)

      assert_equal(expected, OrderKey.zero)
    end
  end

  def test_decrement
    assert_equal("a0", OrderKey.new("a1").decrement)
    assert_equal("Zz", OrderKey.new("a0").decrement)
  end

  def test_decrement_raises_for_minimum_integer
    error = assert_raises(FractionalIndexer::Error) { OrderKey.new("A" + "0" * 26).decrement }

    assert_equal(
      "invalid order key: 'A00000000000000000000000000' description: it cannot decrement for min integer",
      error.message,
    )
  end

  def test_fractional
    assert_equal("0zZ", OrderKey.new("b120zZ").fractional)
  end

  def test_fractional_raises_for_trailing_zero
    error = assert_raises(FractionalIndexer::Error) { OrderKey.new("a0010").fractional }

    assert_equal("invalid order key: 'a0010' description: fractional '010' is invalid.", error.message)
  end

  def test_increment
    assert_equal("a0", OrderKey.new("Zz").increment)
    assert_equal("a2", OrderKey.new("a1").increment)
  end

  def test_increment_raises_for_maximum_integer
    error = assert_raises(FractionalIndexer::Error) { OrderKey.new("z" * 27).increment }

    assert_equal(
      "invalid order key: 'zzzzzzzzzzzzzzzzzzzzzzzzzzz' description: it cannot increment for max integer",
      error.message,
    )
  end

  def test_integer
    assert_equal("d012A", OrderKey.new("d012A").integer)
    assert_equal("b12", OrderKey.new("b12z").integer)
  end

  def test_integer_raises_for_short_integer
    error = assert_raises(FractionalIndexer::Error) { OrderKey.new("b1").integer }

    assert_equal("invalid order key: 'b1' description: integer 'b1' is invalid.", error.message)
  end

  def test_integer_raises_for_invalid_prefix
    error = assert_raises(FractionalIndexer::Error) { OrderKey.new("!9").integer }

    assert_equal("invalid order key: '!9' description: prefix '!' is invalid. It should be a-z or A-Z.", error.message)
  end

  def test_maximum_integer?
    assert_predicate(OrderKey.new("z" * 27 + "a"), :maximum_integer?)
    refute_predicate(OrderKey.new("z" * 26 + "a"), :maximum_integer?)
  end

  def test_minimum_integer?
    assert_predicate(OrderKey.new("A" + "0" * 26 + "z"), :minimum_integer?)
    refute_predicate(OrderKey.new("A" + "0" * 25 + "1"), :minimum_integer?)
  end

  def test_minimum?
    assert_predicate(OrderKey.new("A" + "0" * 26), :minimum?)
    refute_predicate(OrderKey.new("A" + "0" * 26 + "2"), :minimum?)
    refute_predicate(OrderKey.new("A" + "0" * 25 + "1"), :minimum?)
  end

  def test_present?
    refute_predicate(OrderKey.new(nil), :present?)
    refute_predicate(OrderKey.new(""), :present?)
    assert_predicate(OrderKey.new("a0"), :present?)
  end
end
