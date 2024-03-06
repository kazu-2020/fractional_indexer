module FractionalIndexer
  class Configuration
    attr_writer :base

    # allow only ASCII characters
    DIGITS_LIST = {
      base_10: ('0'..'9').to_a,
      base_62: ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a,
      base_94: ('!'..'~').to_a
    }.freeze

    def digits
      DIGITS_LIST[base] || DIGITS_LIST[:base_62]
    end

    private

    attr_reader :base
  end
end
