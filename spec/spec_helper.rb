require "bundler/setup"
require "fractional_indexer"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after do
    FractionalIndexer.configure do |config|
      config.base = :base_62
    end
  end
end
