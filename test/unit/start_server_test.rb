require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class StartServerTest < Test::Unit::TestCase

    def test_should_run_server_with_given_port_number
      application.config.port(6666)

      application.start_server

      assert_run("java -jar #{runtime_config.jar_path} --serverHandlerPrefix jstd --port #{config.port}")
    end

  end
end
