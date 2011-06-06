module JsTestDriver
  module Commands

    class GenerateCoverageReport < BaseCommand

      attr_reader :runtime_config, :output_path

      def initialize(runtime_config, output_path)
        super('genhtml')

        @runtime_config = runtime_config
        @output_path = File.expand_path(output_path)

        option('-o', output_dir)
        arg(data_file_path)
      end

      def output_dir
        File.join(output_path, 'coverage')
      end

      def data_file_path
        config_path = File.basename(runtime_config.config_yml_path)
        file_name = config_path + '-coverage.dat'
        File.join(output_path, file_name)
      end

    end

  end
end
