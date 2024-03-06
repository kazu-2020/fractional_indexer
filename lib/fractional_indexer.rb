require "fractional_indexer/version"

module FractionalIndexer
  autoload :Configuration, "fractional_indexer/configuration"
  autoload :Decrementer,   "fractional_indexer/decrementer"
  autoload :Incrementer,   "fractional_indexer/incrementer"
  autoload :Midpointer, "fractional_indexer/midpointer"
  autoload :Integer, "fractional_indexer/integer"
  autoload :OrderKey, "fractional_indexer/order_key"

  class FractionalIndexerError < StandardError; end

  @@configuration = Configuration.new

  def self.configure
    yield(configuration) if block_given?

    configuration
  end

  def self.configuration
    @@configuration
  end

end
