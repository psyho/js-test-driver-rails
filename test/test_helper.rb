require 'rubygems'
require 'bundler'

Bundler.setup

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'js_test_driver'))

require 'test/unit'
require 'mocha'
