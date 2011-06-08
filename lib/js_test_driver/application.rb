module JsTestDriver

  class Application

    attr_reader :runtime_config

    def initialize(opts = {})
      @runtime_config = JsTestDriver::RuntimeConfig.new(opts)
      @runtime_config.config_factory = config_factory
    end

    def config
      runtime_config.config
    end

    def start_server(opts = {})
      JsTestDriver::CLI::StartServer.new(jstd_jar_command, runner).run(opts)
    end

    def capture_browsers(opts = {})
      JsTestDriver::CLI::CaptureBrowsers.new(config, runner).run(opts)
    end

    def run_tests(opts = {})
      JsTestDriver::CLI::RunTests.new(jstd_jar_command, runner).run(opts)
    end

    def run(opts = {})
      JsTestDriver::CLI::Run.new(jstd_jar_command, runner, config, coverage_command).run(opts)
    end

    def config_factory
      JsTestDriver::ConfigFactory.new(runtime_config)
    end

    protected

    def runner
      JsTestDriver::Runner.new
    end

    def jstd_jar_command
      JsTestDriver::Commands::JstdJarCommand.new(runtime_config, config)
    end

    def coverage_command
      JsTestDriver::Commands::GenerateCoverageReport.new(runtime_config)
    end

  end

end
