module JsTestDriver
  # The Runner class is used
  class Runner

    def initialize(attributes = {})
      self.attributes = attributes
    end

    # configuration, by default it's parsed from config_path
    attr_writer :config

    def config
      @config ||= parse_config
    end

    attr_writer :generated_files_dir

    # this is where the generated files will be saved, by default this is `pwd`/.js_test_driver
    #
    # the generated files are the config yml file and the fixture files
    def generated_files_dir
      @generated_files_dir || default_generated_files_dir
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

    # this is where the config yml file will be saved, by default its saved in the generated files
    # directory under the name jsTestDriver.conf
    attr_writer :tmp_path

    def config_yml_path
      @tmp_path ||= default_config_yml_path
    end

    # starts the server on the default port specified in the config file
    def start_server
      start_server_command.run
    end

    # captures the browsers
    #
    # by default it will capture the browsers specified in the config,
    # but you can pass an argument like 'opera,chrome,firefox' to capture opera, chrome and firefox
    def capture_browsers(browsers = nil)
      capture_browsers_command(browsers).run
    end

    # runs the tests specified by the argument
    #
    # by default it will run all the tests, but you can pass a string like:
    # 'TestCase' or 'TestCase.test'
    # to run either a single test case or a single test
    def run_tests(tests = nil)
      run_tests_command(tests).run  
    end

    protected

    def start_server_command
      execute_jar_command.option('--port', config.port)
    end

    def run_tests_command(tests)
      run_with_config.option('--tests', tests || "all") #.option('--runnerMode', 'DEBUG')
    end

    def capture_browsers_command(browsers)
      browsers ||= config.browsers.join(',')
      raise ArgumentError.new("No browsers defined!") if browsers == ""
      run_with_config.option('--browser', browsers)
    end

    def run_with_config
      save_config_file(config_yml_path)
      execute_jar_command.option('--config', config_yml_path)
    end

    def execute_jar_command
      Command.new('java').option('-jar', jar_path)
    end

    def parse_config
      source = ""
      if File.exist?(config_path)
        source = File.read(config_path)
      else
        warn("Could not find JS Test Driver config: '#{config_path}', assuming empty config file!")
      end
      config = JsTestDriver::Config.parse(source)
      config.config_dir = generated_files_dir
      return config
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

    def default_config_yml_path
      return File.expand_path("jsTestDriver.conf", generated_files_dir)
    end

    def default_generated_files_dir
      return File.expand_path(".js_test_driver")
    end

    private

    def save_config_file(path)
      Dir.mkdir(generated_files_dir) unless File.exists?(generated_files_dir)
      File.open(path, "w+") { |f| f.puts config.to_s }
      config.save_fixtures
    end

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