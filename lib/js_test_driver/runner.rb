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
      command = execute_jar

      add_start_server(command)

      command.run
    end

    # captures the browsers
    #
    # by default it will capture the browsers specified in the config,
    # but you can pass an argument like 'opera,chrome,firefox' to capture opera, chrome and firefox
    def capture_browsers(browsers = nil)
      browsers ||= ''
      browsers = browsers.split(',')
      browsers = config.browsers if browsers.empty?

      url = config.server + "/capture"

      browsers.each do |browser|
        spawn("#{browser} \'#{url}\'")
      end
    end

    # runs the tests specified by the argument
    #
    # by default it will run all the tests, but you can pass a string like:
    # 'TestCase' or 'TestCase.test'
    # to run either a single test case or a single test
    def run_tests(tests = nil)
      command = execute_jar

      add_with_config(command)
      add_run_tests(command, tests)

      command.run
    end

    def start_server_capture_and_run(tests, browsers, output_xml_path = nil, console = nil)
      command = execute_jar

      add_start_server(command)
      add_with_config(command)
      add_capture_browsers(command, browsers)
      add_run_tests(command, tests)
      add_output_directory(command, output_xml_path) if output_xml_path
      add_capture_console(command) if console

      command.run
    end

    def add_start_server(command)
      command.option('--port', config.port)
    end

    def add_run_tests(command, tests)
      command.option('--tests', tests || "all")
    end

    def add_capture_browsers(command, browsers)
      browsers ||= config.browsers.join(',')
      raise ArgumentError.new("No browsers defined!") if browsers == ""
      command.option('--browser', browsers)
    end

    def add_output_directory(command, path)
      path = File.expand_path(path)
      FileUtils.mkdir_p(path) unless File.exists?(path)
      command.option('--testOutput', path)
    end

    def add_capture_console(command)
      command.option('--captureConsole')
    end

    def add_with_config(command)
      save_config_file(config_yml_path)
      command.option('--config', config_yml_path)
    end

    def execute_jar
      Command.new('java').option('-jar', jar_path)
    end

    protected

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
      root = defined?(::Rails) ? ::Rails.root.to_s : '.'
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
