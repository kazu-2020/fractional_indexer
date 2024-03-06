module FractionalIndexer
  class OrderKey
    INTEGER_BASE_DIGIT = 2.freeze

    attr_reader :key

    def initialize(key)
      @key = key
    end

    def self.zero
      'a' + FractionalIndexer.configuration.digits.first
    end

    def fractional
      result = key[integer_digits..]
      raise_error("fractional '#{result}' is invalid.") unless valid_fractional?(result)

      result
    end

    def integer
      result = key[0, integer_digits]
      raise_error("integer '#{result}' is invalid.") unless valid_integer?(result)

      result
    end

    def smallest_integer?
      key == smallest_integer
    end

    private

    def digits
      FractionalIndexer.configuration.digits
    end

    def integer_digits
      if ('a'..'z').cover?(key[0])
        key.ord - 'a'.ord + INTEGER_BASE_DIGIT
      elsif ('A'..'Z').cover?(key[0])
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
      fractional[-1] != '0'
    end

    def valid_integer?(integer)
      integer.length == integer_digits
    end
  end
end
