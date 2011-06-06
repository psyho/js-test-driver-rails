module JsTestDriver
  module Commands

    class JstdJarCommand < BaseCommand

      attr_reader :runtime_config

      def initialize(runtime_config)
        super('java')
        @runtime_config = runtime_config

        option('-jar', runtime_config.jar_path)
      end

      def with_config
        runtime_config.config.save(runtime_config.config_yml_path)
        return option('--config', runtime_config.config_yml_path)
      end

      def start_server
        return option('--port', runtime_config.config.port)
      end

      def run_tests(tests = nil)
        return option('--tests', tests || "all")
      end

      def capture_browsers(browsers = nil)
        browsers ||= runtime_config.config.browsers.join(',')
        raise ArgumentError.new("No browsers defined!") if browsers == ""
        return option('--browser', browsers)
      end

      def output_directory(path)
        path = File.expand_path(path)
        FileUtils.mkdir_p(path) unless File.exists?(path)
        return option('--testOutput', path)
      end

      def capture_console
        return option('--captureConsole')
      end

    end

  end
end
