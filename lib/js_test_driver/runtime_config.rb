module JsTestDriver
  # The RuntimeConfig class holds the various paths that the application
  # uses, as well as the actual JsTestDriver configuration
  class RuntimeConfig

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
      config.save(config_yml_path)
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
      return file("jsTestDriver.conf", generated_files_dir)
    end

    def default_generated_files_dir
      return file(".js_test_driver")
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
