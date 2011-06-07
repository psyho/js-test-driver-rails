module JsTestDriver
  module Commands

    class GenerateCoverageReport < BaseCommand

      attr_reader :runtime_config

      def initialize(runtime_config)
        super('genhtml')
        @runtime_config = runtime_config
      end

      def output_path(value)
        value = File.expand_path(value)
        option('-o', output_dir(value))
        arg(data_file_path(value))
      end

      protected

      def output_dir(output_path)
        File.join(output_path, 'coverage')
      end

      def data_file_path(output_path)
        config_path = File.basename(runtime_config.config_yml_path)
        file_name = config_path + '-coverage.dat'
        File.join(output_path, file_name)
      end

    end

  end
end
