require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class RunTestsTest < Test::Unit::TestCase

    def test_should_run_all_tests_by_default
      application.run_tests

      assert_run("java -jar #{runtime_config.jar_path} --serverHandlerPrefix jstd --config #{runtime_config.config_yml_path} --tests all --reset")
    end

    def test_should_run_selected_tests
      application.run_tests(:tests => 'MyTestCase.some_test')

      assert_run("java -jar #{runtime_config.jar_path} --serverHandlerPrefix jstd --config #{runtime_config.config_yml_path} --tests MyTestCase.some_test --reset")
    end

  end
end

