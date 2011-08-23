module JsTestDriver
  module Commands

    class GenerateCoverageReport < BaseCommand

      attr_reader :runtime_config

      def initialize(runtime_config)
        super('genhtml')
        option('-o', runtime_config.coverage_files_path)
        arg(runtime_config.coverage_data_file)
      end

      protected

      def executable_not_found!
        warn("Could not find executable: #{@command}")
      end

    end

  end
end
