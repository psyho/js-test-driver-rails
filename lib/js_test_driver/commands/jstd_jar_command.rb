module JsTestDriver
  module Commands

    class JstdJarCommand < BaseCommand

      attr_reader :runtime_config, :config

      def initialize(runtime_config, config)
        super('java')
        @runtime_config = runtime_config
        @config = config

        option('-jar', runtime_config.jar_path)
        option('--serverHandlerPrefix', 'jstd')
      end

      def with_config
        return option('--config', runtime_config.config_yml_path)
      end

      def start_server
        return option('--port', config.port)
      end

      def run_tests(tests = nil)
        return option('--tests', tests || "all")
      end

      def capture_browsers(browsers = nil)
        browsers ||= config.browsers.join(',')
        raise ArgumentError.new("No browsers defined!") if browsers == ""
        return option('--browser', browsers)
      end

      def output_directory(path)
        return option('--testOutput', path)
      end

      def output_xml
        return output_directory(runtime_config.test_xml_data_path)
      end

      def capture_console
        return option('--captureConsole')
      end

      def verbose
        return option('--verbose')
      end

      def runner_mode(mode)
        return option('--runnerMode', mode)
      end

      def reset_runner
        return option('--reset')
      end

      def browser_timeout(timeout)
        return option('--browserTimeout', timeout)
      end
    end

  end
end
