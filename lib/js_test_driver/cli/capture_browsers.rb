module JsTestDriver
  module CLI

    class CaptureBrowsers

      attr_reader :config, :runner

      def initialize(config, runner)
        @config = config
        @runner = runner
      end

      def run(opts = {})
        browsers = opts[:browsers] || ''
        browsers = browsers.split(',')
        browsers = config.browsers if browsers.empty?

        url = config.server + "/capture?strict"

        browsers.each do |name|
          runner.runbg(browser_command(name, url))
        end
      end

      protected

      def browser_command(name, url)
        JsTestDriver::Commands::BaseCommand.new(name).arg(url).to_s
      end

    end

  end
end
