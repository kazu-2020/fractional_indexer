module FractionalIndexer
  class FractionalIndexerError < StandardError; end

  class Integer
    BASE_DIGIT = 2.freeze
    DIGITS = ('0'..'9').to_a.freeze

    def initialize(digits = DIGITS)
      @digits = digits
    end

    def decrement(position)
      # validate!(position)

      order_key, *digs = position.chars
      borrow = true

      (digs.length - 1).downto(0) do |i|
        decremented_index = digits.index(digs[i]) - 1

        if borrow?(decremented_index)
          digs[i] = digits[-1]
        else
          digs[i] = digits[decremented_index]
          borrow = false

          break
        end
      end

      return order_key + digs.join unless borrow

      return 'Z' + digits[-1] if order_key === 'a'
      return nil if order_key === 'A'

      new_order_key = (order_key.ord - 1).chr
      new_order_key < 'Z' ? digs.push(digits[-1]) : digs.pop

      new_order_key + digs.join
    end

    def length!(order_key)
      if ('a'..'z').cover?(order_key)
        order_key.ord - 'a'.ord + BASE_DIGIT
      elsif ('A'..'Z').cover?(order_key)
        'Z'.ord - order_key.ord + BASE_DIGIT
      else
        raise FractionalIndexerError, "Invalid order key: #{order_key}"
      end
    end

    def smallest_integer
      'A' + digits[0] * 26
    end

    def zero
      'a' + digits[0]
    end

    private

    attr_reader :digits

    def validate!(position)
      if position.length != length!(position[0])
        raise FractionalIndexerError, "Invalid integer part of order key: #{position[0]}"
      end
    end

    def carry_over?(index)
      index == digits.length
    end

    def borrow?(index)
      index == -1
    end
  end
end
