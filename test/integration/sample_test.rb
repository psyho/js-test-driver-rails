require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class SampleTest < Test::Unit::TestCase

    def test_running_sample_specs
      config_path = File.expand_path('../../sample/config/js_test_driver.rb', __FILE__)
      app = JsTestDriver::Application.new(:config_path => config_path)

      assert app.run(:output_xml => true), 'running tests should return a success'
    end

  end
end
