# frozen_string_literal: true

require_relative "lib/fractional_indexer/version"

Gem::Specification.new do |spec|
  spec.name = "fractional_indexer"
  spec.version = FractionalIndexer::VERSION
  spec.authors = ["matazou"]
  spec.email = ["64774307+kazu-2020@users.noreply.github.com"]
  spec.homepage = "https://github.com/kazu-2020/fractional_indexer"
  spec.summary = "efficient data insertion and sorting through fractional indexing"
  spec.description = <<~DESCRIPTION
    FractionalIndexer is a Ruby gem designed to leverage fractional indexing for ordering within lists or data structures.
    it enables efficient sorting and insertion of large volumes of data.
  DESCRIPTION
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/kazu-2020/fractional_indexer/releases"
  spec.metadata["bug_tracker_uri"] = "https://github.com/kazu-2020/fractional_indexer/issues"
  spec.metadata["source_code_uri"] = "https://github.com/kazu-2020/fractional_indexer"
  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "LICENSE.txt", "README.md"]
  end

  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.1"
end
