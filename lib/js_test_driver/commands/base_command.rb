module JsTestDriver
  module Commands

    class BaseCommand
      def initialize(executable)
        @command = "#{executable}"
        ensure_installed!

        @options = []
        @args = []
      end

      def option(name, value = nil)
        @options << name
        @options << escape(value)
        self
      end

      def arg(value)
        @args << escape(value)
        self
      end

      def to_s
        return ([@command] + @options + @args).compact.join(' ')
      end

      private

      def ensure_installed!
        if %x[which #{@command}].strip.empty?
          raise JsTestDriver::MissingDependencyError.new("Could not find executable: #{@command}")
        end
      end

      def escape(value)
        return "'#{value}'" if value && value =~ /\s/
        return value
      end
    end

  end
end
