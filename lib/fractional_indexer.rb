# frozen_string_literal: true

require "fractional_indexer/version"

require "fractional_indexer/configuration"
require "fractional_indexer/decrementer"
require "fractional_indexer/incrementer"
require "fractional_indexer/midpointer"
require "fractional_indexer/order_key"

module FractionalIndexer
  class Error < StandardError; end

  @configuration = Configuration.new

  [Decrementer, Incrementer, Midpointer, OrderKey].each do |klass|
    klass.send(:define_method, :digits) { FractionalIndexer.configuration.digits }
  end

  def self.configure
    yield(configuration) if block_given?

    configuration
  end

  def self.configuration
    @configuration
  end

  def self.generate_key(prev_key: nil, next_key: nil)
    return OrderKey.zero if prev_key.nil? && next_key.nil?

    raise Error, "prev_key and next_key cannot be empty" if prev_key&.empty? || next_key&.empty?

    if !prev_key.nil? && !next_key.nil? && prev_key >= next_key
      raise Error, "#{prev_key} is not less than #{next_key}"
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

  def self.generate_keys(prev_key: nil, next_key: nil, count: 1)
    return [] if count <= 0
    return [generate_key(prev_key: prev_key, next_key: next_key)] if count == 1

    if next_key.nil?
      base_order_key = generate_key(prev_key: prev_key)
      result = [base_order_key]

      (count - 1).times do
        result << generate_key(prev_key: result.last)
      end

      return result
    end

    if prev_key.nil?
      base_order_key = generate_key(next_key: next_key)
      result = [base_order_key]

      (count - 1).times do
        result << generate_key(next_key: result.last)
      end

      return result.reverse
    end

    mid = count / 2
    base_order_key = generate_key(prev_key: prev_key, next_key: next_key)

    [
      *generate_keys(prev_key: prev_key, next_key: base_order_key, count: mid),
      base_order_key,
      *generate_keys(prev_key: base_order_key, next_key: next_key, count: count - mid - 1),
    ]
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
