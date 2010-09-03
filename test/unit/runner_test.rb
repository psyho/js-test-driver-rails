require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class RunnerTest < Test::Unit::TestCase

    def given_a_runner(opts = {})
      return JsTestDriver::Runner.new(opts)  
    end

    def test_should_have_default_config_path
      # given
      runner = given_a_runner

      # then
      assert runner.config_path
    end

    def test_should_have_default_jar_path
      # given
      runner = given_a_runner

      # then
      assert runner.jar_path
    end

    def test_should_have_default_tmp_path
      # given
      runner = given_a_runner

      # then
      assert runner.config_yml_path
    end

    def expect_command_to_be_executed(cmd)
      JsTestDriver::Runner::Command.any_instance.expects(:system).with(cmd)
    end

    def test_should_run_server_with_given_port_number
      config = JsTestDriver::Config.new(:port => 6666)
      runner = given_a_runner(:config => config)

      expect_command_to_be_executed("java -jar #{runner.jar_path} --port #{config.port}")

      runner.start_server
    end

    def test_should_run_all_tests_by_default
      runner = given_a_runner(:config => JsTestDriver::Config.new)

      expect_command_to_be_executed("java -jar #{runner.jar_path} --config #{runner.config_yml_path} --tests all")

      runner.run_tests
    end

    def test_should_run_selected_tests
      runner = given_a_runner(:config => JsTestDriver::Config.new)

      expect_command_to_be_executed("java -jar #{runner.jar_path} --config #{runner.config_yml_path} --tests MyTestCase.some_test")

      runner.run_tests('MyTestCase.some_test')
    end

    def test_should_raise_exception_if_no_browsers_defined_to_capture
      runner = given_a_runner(:config => JsTestDriver::Config.new)

      assert_raises(ArgumentError) do
        runner.capture_browsers
      end
    end

    def test_should_capture_default_browsers
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      expect_command_to_be_executed("java -jar #{runner.jar_path} --config #{runner.config_yml_path} --browser foo,bar,baz")

      runner.capture_browsers
    end

    def test_should_capture_given_browsers
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      expect_command_to_be_executed("java -jar #{runner.jar_path} --config #{runner.config_yml_path} --browser aaa,bbb")

      runner.capture_browsers('aaa,bbb')
    end

    def test_should_run_with_all_arguments_at_once
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      expect_command_to_be_executed("java -jar #{runner.jar_path} --port 4224 --config #{runner.config_yml_path} --browser aaa,bbb --tests TestCase --testOutput #{File.expand_path('.js_test_driver')} --captureConsole")

      runner.start_server_capture_and_run('TestCase', 'aaa,bbb', '.js_test_driver', true)
    end

  end
end