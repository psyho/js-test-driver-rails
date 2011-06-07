module JsTestDriver
  module CLI

    class StartServer

      attr_reader :jstd_jar_command, :runner

      def initialize(jstd_jar_command, runner)
        @jstd_jar_command = jstd_jar_command
        @runner = runner
      end

      def run(opts = {})
        runner.run(jstd_jar_command.start_server.to_s)
      end

    end

  end
end
