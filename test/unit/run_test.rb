require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class RunTest < Test::Unit::TestCase

:wa
    def test_should_run_with_all_arguments_at_once
      config.browser 'foo', 'bar', 'baz'

      application.run(:tests => 'TestCase',
                      :browsers => 'aaa,bbb',
                      :output_xml_path => '.js_test_driver',
                      :capture_console => true)

      assert_run("java -jar #{runtime_config.jar_path} --port 4224 --config #{runtime_config.config_yml_path} --browser aaa,bbb --tests TestCase --testOutput #{File.expand_path('.js_test_driver')} --captureConsole")
    end

    def test_when_measuring_coverage
      config.measure_coverage
      config.browser 'foo'

      application.run(:output_xml_path => '.js_test_driver')

      assert_run("genhtml -o #{File.expand_path('.js_test_driver/coverage')} #{File.expand_path('.js_test_driver/jsTestDriver.conf-coverage.dat')}")
    end

  end
end

