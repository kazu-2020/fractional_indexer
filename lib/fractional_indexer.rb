require "fractional_indexer/version"

module FractionalIndexer
  autoload :Configuration, "fractional_indexer/configuration"
  autoload :Decrementer,   "fractional_indexer/decrementer"
  autoload :Incrementer,   "fractional_indexer/incrementer"
  autoload :Midpointer,    "fractional_indexer/midpointer"
  autoload :OrderKey,      "fractional_indexer/order_key"

  class FractionalIndexerError < StandardError; end

  @@configuration = Configuration.new

  def self.configure
    yield(configuration) if block_given?

    configuration
  end

  def self.configuration
    @@configuration
  end

  def self.generate_key(prev_key: nil, next_key: nil)
    if prev_key.nil? && next_key.nil?
      return OrderKey.zero
    end

    if prev_key&.empty? || next_key&.empty?
      raise FractionalIndexerError, "prev_key and next_key cannot be empty"
    end

    if !prev_key.nil? && !next_key.nil? && prev_key >= next_key
      raise FractionalIndexerError, "#{prev_key} is not less than #{next_key}"
    end

    prev_order_key = OrderKey.new(prev_key)
    next_order_key = OrderKey.new(next_key)

    if !prev_order_key.present?
      if next_order_key.minimum_integer?
        return next_order_key.integer + Midpointer.execute('', next_order_key.fractional)
      end

      return next_order_key.integer < next_key ? next_order_key.integer : next_order_key.decrement
    end

    if !next_order_key.present?
      if prev_order_key.maximum_integer?
        return prev_order_key.integer + Midpointer.execute(prev_order_key.fractional, '')
      end

      return prev_order_key.increment
    end

    return prev_order_key.integer + Midpointer.execute(prev_order_key.fractional, next_order_key.fractional) if prev_order_key.integer == next_order_key.integer

    incremented_order_key = prev_order_key.increment
    incremented_order_key < next_key ?  incremented_order_key : prev_order_key.integer + Midpointer.execute(prev_order_key.fractional, nil)
  end
end
