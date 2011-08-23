module JsTestDriver
  module CLI

    class RunTests

      attr_reader :jstd_jar_command, :runner

      def initialize(jstd_jar_command, runner)
        @jstd_jar_command = jstd_jar_command
        @runner = runner
      end

      def run(opts = {})
        jstd_jar_command.with_config.run_tests(opts[:tests]).reset_runner

        runner.run(jstd_jar_command.to_s)
      end

    end

  end
end
