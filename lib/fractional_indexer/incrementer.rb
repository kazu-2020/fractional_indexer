# frozen_string_literal: true

module FractionalIndexer
  class Incrementer
    def self.execute(order_key)
      new.execute(order_key)
    end

    def execute(order_key)
      prefix, *digs = order_key.integer.chars
      carry = true

      (digs.length - 1).downto(0) do |i|
        incremented_index = digits.index(digs[i]) + 1

        if carry_over?(incremented_index)
          digs[i] = digits[0]
        else
          digs[i] = digits[incremented_index]
          carry   = false

          break
        end
      end

      return prefix + digs.join unless carry

      return order_key.class.zero if prefix == "Z"
      return if prefix == "z"

      new_key = (prefix.ord + 1).chr
      new_key > "a" ? digs.push("0") : digs.pop

      new_key + digs.join
    end

    private

    def carry_over?(index)
      index == digits.length
    end
  end
end
