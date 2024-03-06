module FractionalIndexer
  class Midpointer
    def self.execute(prev_pos = nil, next_pos = nil)
      new.execute(prev_pos, next_pos)
    end

    def execute(prev_pos = nil, next_pos = nil)
      prev_pos = prev_pos.to_s
      next_pos = next_pos.to_s

      if prev_pos.empty? && next_pos.empty?
        return digits[digits.length / 2]
      end

      validate_positions!(prev_pos, next_pos)

      if !next_pos.empty?
        n = 0

        # Get a common prefix for prev_pos and next_pos.
        # Also add to the prefix the number of consecutive "0 "s in next_pos.
        # Example:
        #  prev_pos = "123", next_pos = "1230005"
        #  prefix = "123000"
        while (prev_pos[n] || digits.first) == next_pos[n]
          n += 1
        end

        return next_pos[0, n] + execute(prev_pos[n..], next_pos[n..]) if n > 0
      end

      digit_a = prev_pos.empty?   ? 0             : digits.index(prev_pos[0])
      digit_b = next_pos.empty?   ? digits.length : digits.index(next_pos[0])

      if digit_b - digit_a > 1
        mid_digit = ((digit_a + digit_b) / 2.0).round

        return digits[mid_digit]
      end

      if next_pos.length > 1
        next_pos[0]
      else
        digits[digit_a] + execute(prev_pos[1..], nil)
      end
    end

    private

    def digits
      FractionalIndexer.configuration.digits
    end

    def validate_positions!(prev_pos, next_pos)
      if !next_pos.empty? && prev_pos >= next_pos
        raise FractionalIndexerError, "prev_pos must be less than next_pos"
      end

      # NOTE
      # In a string, "0.3" and "0.30" are mathematically equivalent.
      # Therefore, a trailing "0" is prohibited.
      if prev_pos.end_with?(digits.first) || next_pos.end_with?(digits.first)
        raise FractionalIndexerError, "prev_pos and next_pos cannot end with #{digits.first}"
      end
    end
  end
end