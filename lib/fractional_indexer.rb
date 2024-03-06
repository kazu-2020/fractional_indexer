# frozen_string_literal: true

require "fractional_indexer/version"

module FractionalIndexer
  autoload :Configuration, "fractional_indexer/configuration"
  autoload :Decrementer,   "fractional_indexer/decrementer"
  autoload :Incrementer,   "fractional_indexer/incrementer"
  autoload :Midpointer,    "fractional_indexer/midpointer"
  autoload :OrderKey,      "fractional_indexer/order_key"

  class FractionalIndexerError < StandardError; end

  @configuration = Configuration.new

  def self.configure
    yield(configuration) if block_given?

    configuration
  end

  def self.configuration
    @configuration
  end

  def self.generate_key(prev_key: nil, next_key: nil)
    return OrderKey.zero if prev_key.nil? && next_key.nil?

    raise FractionalIndexerError, "prev_key and next_key cannot be empty" if prev_key&.empty? || next_key&.empty?

    if !prev_key.nil? && !next_key.nil? && prev_key >= next_key
      raise FractionalIndexerError, "#{prev_key} is not less than #{next_key}"
    end

    prev_order_key = OrderKey.new(prev_key)
    next_order_key = OrderKey.new(next_key)

    return decrement(next_order_key) unless prev_order_key.present?
    return increment(prev_order_key) unless next_order_key.present?

    if prev_order_key.integer == next_order_key.integer
      return prev_order_key.integer + Midpointer.execute(prev_order_key.fractional, next_order_key.fractional)
    end

    incremented_order_key = prev_order_key.increment
    if incremented_order_key < next_key
      incremented_order_key
    else
      prev_order_key.integer + Midpointer.execute(prev_order_key.fractional, nil)
    end
  end

  def self.decrement(order_key)
    return order_key.integer + Midpointer.execute("", order_key.fractional) if order_key.minimum_integer?

    order_key.integer < order_key.key ? order_key.integer : order_key.decrement
  end

  def self.increment(order_key)
    return order_key.integer + Midpointer.execute(order_key.fractional, "") if order_key.maximum_integer?

    order_key.increment
  end
end
