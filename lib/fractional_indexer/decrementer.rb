module FractionalIndexer
  class Decrementer
    def self.execute(order_key)
      new.execute(order_key)
    end

    def execute(order_key)
      prefix, *digs = order_key.integer.chars
      borrow = true

      (digs.length - 1).downto(0) do |i|
        decremented_index = digits.index(digs[i]) - 1

        if borrow?(decremented_index)
          digs[i] = digits[-1]
        else
          digs[i] = digits[decremented_index]
          borrow  = false

          break
        end
      end

      return prefix + digs.join unless borrow

      return 'Z' + digits[-1] if prefix == 'a'
      return nil if prefix == 'A'

      new_key = (prefix.ord - 1).chr
      new_key < 'Z' ? digs.push(digits[-1]) : digs.pop

      new_key + digs.join
    end

    private

    def borrow?(index)
      index == -1
    end

    def digits
      FractionalIndexer.configuration.digits
    end
  end
end
