require "bundler/gem_tasks"

task default: 'test'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/unit/**/*_test.rb']
  test.verbose = true
end
