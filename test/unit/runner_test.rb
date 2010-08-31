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
      assert runner.tmp_path
    end

    def test_should_run_server_with_given_port_number
      config = JsTestDriver::Config.new(:port => 6666)
      runner = given_a_runner(:config => config)

      runner.expects(:system).with("java -jar #{runner.jar_path} --port #{config.port}")

      runner.start_server
    end

  end
end