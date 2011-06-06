require 'json'
require 'fileutils'

require File.expand_path(File.join('..', 'js_test_driver', 'config'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'runner'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'html_fixture'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'missing_dependency_error'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'commands', 'base_command'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'commands', 'jstd_jar_command'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'commands', 'capture_browsers_command'), __FILE__)
require File.expand_path(File.join('..', 'js_test_driver', 'commands', 'generate_coverage_report'), __FILE__)
