require 'rubygems'
require 'bundler'

Bundler.setup

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'js_test_driver'))

require 'test/unit'
require 'mocha'

class Test::Unit::TestCase

  def setup
    clean_up_saved_config_files
  end

  def fixture_dir
    File.expand_path('fixtures', File.dirname(__FILE__))
  end

  def clean_up_saved_config_files
    root_dir = File.expand_path('..', File.dirname(__FILE__))
    Dir["#{root_dir}/**/.js_test_driver"].each do |file|
      FileUtils.rm_rf(file)
    end
  end

end