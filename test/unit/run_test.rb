require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class RunTest < Test::Unit::TestCase

    def test_should_run_with_all_arguments_at_once
      config.browser 'foo', 'bar', 'baz'

      application.run(:tests => 'TestCase',
                      :browsers => 'aaa,bbb',
                      :output_xml => true,
                      :capture_console => true)

      assert_run("java -jar #{runtime_config.jar_path} --serverHandlerPrefix jstd --port 4224 --config #{runtime_config.config_yml_path} --browser aaa,bbb --tests TestCase --testOutput #{runtime_config.test_xml_data_path} --captureConsole")
    end

    def test_when_measuring_coverage
      config.measure_coverage
      config.browser 'foo'

      application.run(:output_xml => true)

      assert_run("genhtml -o #{runtime_config.coverage_files_path} #{runtime_config.coverage_data_file}")
    end

  end
end

