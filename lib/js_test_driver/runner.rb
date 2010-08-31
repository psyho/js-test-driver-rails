module JsTestDriver

  class Runner

    def initialize(attributes = {})
      self.attributes = attributes
    end

    # configuration, by default it's parsed from config_path
    attr_writer :config

    def config
      @config ||= parse_config
    end

    # this is the path of the config file, by default its `pwd`/config/js_test_driver.rb
    attr_writer :config_path

    def config_path
      @config_path ||= default_config_path
    end

    # this is the path to the js test driver jar file, by default it's stored relatively to this file
    attr_writer :jar_path

    def jar_path
      @jar_path ||= default_jar_path
    end

    # this is where the config yml file will be saved, by default its /tmp/js_test_driver.(contents MD5).yml
    attr_writer :tmp_path

    def tmp_path
      @tmp_path ||= default_tmp_path
    end

    def start_server
      start_server_command.run
    end

    protected

    def start_server_command
      execute_jar.option('--port', config.port)
    end

    def execute_jar
      Command.new('java').option('-jar', jar_path)
    end

    def parse_config
      source = ""
      if File.exist?(config_path)
        source = File.read(config_path)
      else
        warn("Could not find JS Test Driver config: '#{config_path}', assuming empty config file!")
      end
      JsTestDriver::Config.parse(source)
    end

    def default_config_path
      root = defined?(RAILS_ROOT) ? RAILS_ROOT : '.'
      return File.expand_path(File.join(root, 'config', 'js_test_driver.rb'))
    end

    def default_jar_path
      current_dir = File.dirname(__FILE__)
      path = File.join(current_dir, '..', '..', 'vendor', 'js_test_driver.jar')
      return File.expand_path(path)
    end

    def default_tmp_path
      dir = Dir.tmpdir
      hash =  Digest::MD5.hexdigest(config.to_s)
      return File.expand_path(File.join(dir, "js_test_driver.#{hash}.yml"))
    end

    private

    def attributes=(values)
      values.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end    

    class Command
      def initialize(executable)
        @command = "#{executable}"  
      end

      def option(name, value = nil)
        value = "'#{value}'" if value && value =~ /\s/
        @command = [@command, name, value].compact.join(' ')
        self
      end

      def run
        system(self.to_s)
      end

      def to_s
        return @command
      end
    end

  end

end