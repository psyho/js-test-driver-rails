require 'rubygems'
require 'bundler'

Bundler.setup

require 'rake'
require 'rake/testtask'
require 'jeweler'

Rake::TestTask.new("test") do |test|
  test.libs << 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.verbose = true
end

Jeweler::Tasks.new do |gem|
  gem.name = "js-test-driver-rails"
  gem.summary = "A wrapper for JsTestDriver for use with ruby/rails projects"
  gem.description = "Use ruby to configure JsTestDriver, capture browsers and run tests."
  gem.email = "adam@pohorecki.pl"
  gem.homepage = "http://github.com/psyho/js-test-driver-rails"
  gem.authors = ["Adam Pohorecki"]
  gem.rubyforge_project = "js-test-driver-rails"
  gem.add_development_dependency "jeweler"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "jeweler"
  gem.add_dependency "rake"
  gem.files = FileList["[A-Z]*", "{bin,generators,lib,test}/**/*"]
end

Jeweler::GemcutterTasks.new
Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "rdoc"
end
