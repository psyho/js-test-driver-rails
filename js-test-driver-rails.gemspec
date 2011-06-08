# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "js_test_driver/version"

Gem::Specification.new do |s|
  s.name        = "js-test-driver-rails"
  s.version     = JsTestDriver::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Pohorecki"]
  s.email       = ["adam@pohorecki.pl"]
  s.homepage    = "http://github.com/psyho/js-test-driver-rails"
  s.summary     = "A wrapper for JsTestDriver for use with ruby/rails projects"
  s.description = "Use ruby to configure JsTestDriver, capture browsers and run tests."

  s.rubyforge_project = "js-test-driver-rails"

  s.add_dependency 'json'
  s.add_dependency 'rake'
  s.add_dependency 'commander'
  s.add_dependency 'selenium-webdriver'
  s.add_development_dependency 'mocha'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
