require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create do |t|
  # test_helper must start SimpleCov before minitest/autorun so the coverage report's at_exit runs after the tests.
  t.framework = %(require "test_helper")
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :test
