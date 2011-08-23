module JsTestDriver
  module Commands

    class BaseCommand
      def initialize(executable)
        @command = executable.to_s
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

      protected

      def executable_not_found!
        raise JsTestDriver::MissingDependencyError.new("Could not find executable: #{@command}")
      end

      private

      def installed?
        !%x[which #{@command}].strip.empty?
      end

      def ensure_installed!
        executable_not_found! unless installed?
      end

      def escape(value)
        return "'#{value}'" if value && value =~ /\s/
        return value
      end
    end

  end
end
