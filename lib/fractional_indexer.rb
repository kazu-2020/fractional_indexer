require "fractional_indexer/version"

module FractionalIndexer
  autoload :Midpoint, "fractional_indexer/midpoint"
  autoload :Configuration, "fractional_indexer/configuration"
  autoload :Integer, "fractional_indexer/integer"

  class Error < StandardError; end
  # Your code goes here...

  @@configuration = Configuration.new

  def self.configure
    yield(configuration) if block_given?

    configuration
  end

  def self.configuration
    @@configuration
  end

end
