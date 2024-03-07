# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fractional_indexer/version"

Gem::Specification.new do |spec|
  spec.name          = "fractional_indexer"
  spec.version       = FractionalIndexer::VERSION
  spec.authors       = ["kazu"]
  spec.email         = ["matazou@gmail.com"]
  spec.summary       = "efficient data insertion and sorting through fractional indexing"
  spec.description   = <<~DESCRIPTION
    FractionalIndexer is a Ruby gem designed to leverage fractional indexing for ordering within lists or data structures.
    it enables efficient sorting and insertion of large volumes of data.
  DESCRIPTION
  spec.homepage      = "https://github.com/kazu-2020/fractional_indexer"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["source_code_uri"] = "https://github.com/kazu-2020/fractional_indexer"
    spec.metadata["changelog_uri"] = "https://github.com/kazu-2020/fractional_indexer"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{lib}/**/*", "LICENSE.txt", "README.md"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
