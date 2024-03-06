module FractionalIndexer
  class OrderKey
    INTEGER_BASE_DIGIT = 2.freeze
    POSITIVE_SIGNS = ('a'..'z').freeze
    NEGATIVE_SIGNS = ('A'..'Z').freeze

    attr_reader :key

    def initialize(key)
      @key = key
    end

    def self.negative?(key)
      NEGATIVE_SIGNS.cover?(key[0])
    end

    def self.positive?(key)
      POSITIVE_SIGNS.cover?(key[0])
    end

    def self.zero
      'a' + FractionalIndexer.configuration.digits.first
    end

    def decrement
      new_order_key = Decrementer.execute(self)
      raise_error("it cannot decrement for min integer") if new_order_key.nil?

      @key = new_order_key
    end

    def fractional
      result = key[integer_digits..]
      raise_error("fractional '#{result}' is invalid.") unless valid_fractional?(result)

      result
    end

    def increment
      new_order_key = Incrementer.execute(self)
      raise_error("it cannot increment for max integer") if new_order_key.nil?

      @key = new_order_key
    end

    def integer
      result = key[0, integer_digits]
      raise_error("integer '#{result}' is invalid.") unless valid_integer?(result)

      result
    end

    def present?
      !(key.nil? || key.empty?)
    end

    def smallest_integer?
      integer == smallest_integer
    end

    private

    def digits
      FractionalIndexer.configuration.digits
    end

    def integer_digits
      if self.class.positive?(key)
        key.ord - 'a'.ord + INTEGER_BASE_DIGIT
      elsif self.class.negative?(key)
        'Z'.ord - key.ord + INTEGER_BASE_DIGIT
      else
        raise_error("prefix '#{key[0]}' is invalid. It should be a-z or A-Z.")
      end
    end

    def raise_error(description = nil)
      raise FractionalIndexerError, "invalid order key: '#{key}' description: #{description}"
    end

    def smallest_integer
      'A' + digits.first * ('a'..'z').count
    end

    def valid_fractional?(fractional)
      !fractional.end_with?(digits.first)
    end

    def valid_integer?(integer)
      integer.length == integer_digits
    end
  end
end
