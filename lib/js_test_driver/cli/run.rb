module JsTestDriver
  module CLI

    class Run

      attr_reader :command, :runner, :config, :coverage_command

      def initialize(jstd_jar_command, runner, config, coverage_command)
        @command = jstd_jar_command
        @runner = runner
        @config = config
        @coverage_command = coverage_command
      end

      def run(opts = {})
        result = run_jstd_command(opts)
        generate_coverage_report(opts)
        return result
      end

      protected

      def run_jstd_command(opts)
        command
          .start_server
          .with_config
          .capture_browsers(opts[:browsers])
          .run_tests(opts[:tests])

        command.output_xml if opts[:output_xml]
        command.capture_console if opts[:capture_console]
        command.verbose if opts[:verbose]
        command.run_mode(opts[:runner_mode]) if opts[:runner_mode]
        command.browser_timeout(opts[:browser_timeout]) if opts[:browser_timeout]

        return runner.run(command.to_s)
      end

      def generate_coverage_report(opts)
        return unless config.measure_coverage? && opts[:output_xml]

        if genhtml_installed?
          runner.run(coverage_command.to_s)
        else
          puts "Could not find genhtml. You must install lcov (sudo apt-get install lcov)"
        end
      end

      def genhtml_installed?
        !%x[which genhtml].strip.empty?
      end

    end

  end
end
