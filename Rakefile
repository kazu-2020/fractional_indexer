require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create do |t|
  # Load SimpleCov before minitest/autorun so coverage is collected after the tests run.
  t.framework = %(require "test_helper")
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :test
