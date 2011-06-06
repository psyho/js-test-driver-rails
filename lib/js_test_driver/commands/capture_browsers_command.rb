module JsTestDriver
  module Commands

    class CaptureBrowsersCommand

      include Enumerable

      def initialize(browsers, url)
        @browsers = browsers
        @url = url
      end

      def each(&block)
        @browsers.each do |browser|
          yield(JsTestDriver::Commands::BaseCommand.new(browser).arg(@url).to_s)
        end
      end

    end

  end
end
