require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class SampleTest < Test::Unit::TestCase

    def test_running_sample_specs
      config = JsTestDriver::Runner.new(:config_path => File.expand_path('../../sample/config/js_test_driver.rb', __FILE__))

      assert config.start_server_capture_and_run
    end

  end
end
