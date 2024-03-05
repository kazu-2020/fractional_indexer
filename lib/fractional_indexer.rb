require "fractional_indexer/version"

module FractionalIndexer
  autoload :Midpoint, "fractional_indexer/midpoint"
  autoload :Integer, "fractional_indexer/integer"

  class Error < StandardError; end
  # Your code goes here...
end
