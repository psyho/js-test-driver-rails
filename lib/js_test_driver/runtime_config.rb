module JsTestDriver
  # The RuntimeConfig class holds the various paths that the application
  # uses, as well as the actual JsTestDriver configuration
  class RuntimeConfig

    def initialize(attributes = {})
      self.attributes = attributes
    end

    attr_accessor :config_factory

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
      dir(@generated_files_dir || default_generated_files_dir)
    end

    # this is the path of the config file, by default its `pwd`/config/js_test_driver.rb
    attr_writer :config_path

    def config_path
      file(@config_path ||= default_config_path)
    end

    # this is the path to the js test driver jar file, by default it's stored relatively to this file
    attr_writer :jar_path

    def jar_path
      file(@jar_path ||= default_jar_path)
    end

    # this is where the config yml file will be saved, by default its saved in the generated files
    # directory under the name jsTestDriver.conf
    attr_writer :tmp_path

    def config_yml_path
      file(@tmp_path ||= default_config_yml_path)
    end

    # This is the directory where the coverage HTML files will be saved
    attr_writer :coverage_files_path

    def coverage_files_path
      dir(@coverage_files_path ||= default_coverage_files_path)
    end

    # This is the file in which js-test-driver saves coverage data
    # it is not configurable
    def coverage_data_file
      file_name = File.basename(config_yml_path + '-coverage.dat')
      return file(file_name, test_xml_data_path)
    end

    # This is where the XML files with test results will be saved
    attr_writer :test_xml_data_path

    def test_xml_data_path
      dir(@test_xml_data_path ||= default_test_xml_data_path)
    end

    # This is where the fixtures will be saved
    attr_writer :fixture_dir

    def fixture_dir
      dir(@fixture_dir ||= default_fixture_dir)
    end

    # This is where the remote browser scripts will be saved
    attr_writer :remote_browsers_dir

    def remote_browsers_dir
      dir(@remote_browsers_dir ||= default_remote_browsers_dir)
    end

    protected

    def parse_config
      source = ""
      if File.exist?(config_path)
        source = File.read(config_path)
      else
        warn("Could not find JS Test Driver config: '#{config_path}', assuming empty config file!")
      end
      return config_factory.parse(source).save
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
      return file("jsTestDriver.conf", generated_files_dir)
    end

    def default_generated_files_dir
      return dir(".js_test_driver")
    end

    def default_coverage_files_path
      return dir('coverage', generated_files_dir)
    end

    def default_test_xml_data_path
      return dir('tests', generated_files_dir)
    end

    def default_fixture_dir
      return dir('fixtures', generated_files_dir)
    end

    def default_remote_browsers_dir
      return dir('browsers', generated_files_dir)
    end

    private

    def dir(name, parent = nil)
      path = File.expand_path(name, parent)
      FileUtils.mkdir_p(path) unless File.exist?(path)
      return path
    end

    def file(name, parent = nil)
      path = File.expand_path(name, parent)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
      return path
    end

    def attributes=(values)
      values.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end

  end

end
