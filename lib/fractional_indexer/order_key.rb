# frozen_string_literal: true

module FractionalIndexer
  class OrderKey
    INTEGER_BASE_DIGIT = 2
    POSITIVE_SIGNS = ("a".."z").freeze
    NEGATIVE_SIGNS = ("A".."Z").freeze

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
      "a#{FractionalIndexer.configuration.digits.first}"
    end

    def decrement
      new_order_key = Decrementer.execute(self)
      raise_error("it cannot decrement for min integer") if new_order_key.nil?

      new_order_key
    end

    def fractional
      validate!

      key[integer_digits..]
    end

    def increment
      new_order_key = Incrementer.execute(self)
      raise_error("it cannot increment for max integer") if new_order_key.nil?

      new_order_key
    end

    def integer
      validate!

      key[0, integer_digits]
    end

    def maximum_integer?
      integer == maximum_integer
    end

    def minimum_integer?
      integer == minimum_integer
    end

    def present?
      !(key.nil? || key.empty?)
    end

    private

    def integer_digits(key = self.key)
      if self.class.positive?(key)
        key.ord - "a".ord + INTEGER_BASE_DIGIT
      elsif self.class.negative?(key)
        "Z".ord - key.ord + INTEGER_BASE_DIGIT
      else
        raise_error("prefix '#{key[0]}' is invalid. It should be a-z or A-Z.")
      end
    end

    def maximum_integer
      "z#{digits.last * POSITIVE_SIGNS.count}"
    end

    def raise_error(description = nil)
      raise Error, "invalid order key: '#{key}' description: #{description}"
    end

    def minimum_integer
      "A#{digits.first * POSITIVE_SIGNS.count}"
    end

    def valid_fractional?(fractional)
      !fractional.end_with?(digits.first)
    end

    def valid_integer?(integer)
      integer.length == integer_digits
    end

    def validate!
      integer = key[0, integer_digits]
      raise_error("integer '#{integer}' is invalid.") unless valid_integer?(integer)

      fractional = key[integer_digits..]
      raise_error("fractional '#{fractional}' is invalid.") unless valid_fractional?(fractional)
    end
  end
end
