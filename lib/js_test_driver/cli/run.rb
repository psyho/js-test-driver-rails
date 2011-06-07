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

        command.output_directory(opts[:output_xml_path]) if opts[:output_xml_path]
        command.capture_console if opts[:capture_console]
        command.verbose if opts[:verbose]

        return runner.run(command.to_s)
      end

      def generate_coverage_report(opts)
        return unless config.measure_coverage? && opts[:output_xml_path]

        if genhtml_installed?
          runner.run(coverage_command.output_path(opts[:output_xml_path]).to_s)
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
