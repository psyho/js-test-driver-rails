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

    def expect_spawn(cmd)
      JsTestDriver::Runner.any_instance.expects(:spawn).with(cmd)
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

    def test_should_capture_default_browsers
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      ['foo', 'bar', 'baz'].each do |browser|
        expect_spawn("#{browser} 'http://localhost:4224/capture'")
      end

      runner.capture_browsers
    end

    def test_should_capture_given_browsers
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      ['aaa', 'bbb'].each do |browser|
        expect_spawn("#{browser} 'http://localhost:4224/capture'")
      end

      runner.capture_browsers('aaa,bbb')
    end

    def test_should_run_with_all_arguments_at_once
      runner = given_a_runner(:config => JsTestDriver::Config.new(:browsers => ['foo', 'bar', 'baz']))

      expect_command_to_be_executed("java -jar #{runner.jar_path} --port 4224 --config #{runner.config_yml_path} --browser aaa,bbb --tests TestCase --testOutput #{File.expand_path('.js_test_driver')} --captureConsole")

      runner.start_server_capture_and_run('TestCase', 'aaa,bbb', '.js_test_driver', true)
    end

    def test_when_measuring_coverage
      config = JsTestDriver::Config.new
      config.measure_coverage
      runner = given_a_runner(:config => config)

      JsTestDriver::Runner::Command.any_instance.expects(:system)
      runner.expects(:system).with("genhtml -o #{File.expand_path('.js_test_driver/coverage')} #{File.expand_path('.js_test_driver/jsTestDriver.conf-coverage.dat')}")

      runner.start_server_capture_and_run(nil, 'aaa', '.js_test_driver')
    end

  end
end
