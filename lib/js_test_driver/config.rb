module JsTestDriver
  # The Config class represents the YAML config file that is passed to JsTestDriver
  #
  # includes corresponds to load
  # excludes corresponds to exclude
  # server can be configures either using server, or host and port
  #
  # The configuration is very basic, however the fact that it is done in Ruby, gives the
  # user a significant amount of freedom in terms of what is and is not loaded, and so on
  class Config

    def initialize(runtime_config, attributes = {})
      @runtime_config = runtime_config
      self.attributes = attributes
    end

    # Adds a file to be loaded, the path *must* be relative to the root_dir (which is the current dir by default)
    #
    # JsTestDriver supports globbing
    def includes(*paths)
      self.included_files.concat(expand_globs(paths))
    end

    # Files specified here will not be loaded, it's useful when combined with globbing in includes
    #
    # paths should be relative to root_dir
    def excludes(*paths)
      self.excluded_files.concat(expand_globs(paths))
    end

    # Defines a browser to be captured by default
    #
    # This should be a string with no spaces (if you need to pass parameters to the browser you will
    # need to create a shell script ans put it's name here)
    def browser(*browsers)
      browsers.each do |browser|
        self.browsers << browser
      end
    end

    # Defines a HTML fixture directory
    #
    # the first argument is the directory to scan for html fixtures
    # you can pass also :name and :namespace arguments to define the name and the namespace of the fixture
    #
    # the fixtures will be accessible through:
    # namespace.name["file_name_without the html extension"]
    #
    # by default the namespace is called htmlFixtures
    # and the fixture name is called all
    def fixtures(directory, opts = {})
      fixture = JsTestDriver::HtmlFixture.new(directory, opts[:name], opts[:namespace])
      if html_fixtures.detect{|f| f.name == fixture.name && f.namespace == fixture.namespace}
        raise ArgumentError.new("Fixture #{fixture.namespace}.#{fixture.name} already defined!")
      end
      html_fixtures << fixture
    end

    # Includes the bundled with the gem jasmine js file and an adapter for jasmine
    #
    # There's no hacks or modifications here, so this method is just for the users convenience
    def enable_jasmine
      includes File.join(vendor_directory, "jasmine.js")
      includes File.join(vendor_directory, "JasmineAdapter.js")
    end

    # Adds a JsTestDriver plugin for measuring coverage to the configuration
    def measure_coverage
      @measure_coverage = true
      self.plugins << {
        'name' => 'coverage',
        'jar' => File.join(vendor_directory, 'coverage.jar'),
        'module' => 'com.google.jstestdriver.coverage.CoverageModule'
      }
    end

    # Adds a proxy matcher to configuration. This can be used for integration testing.
    def proxy(pattern)
      return Proxy.new(pattern, proxies)
    end

    def measure_coverage?
      !!@measure_coverage
    end

    # Plugins to include in the config
    def plugins
      @plugins ||= []
    end

    # config variable which has a regular setter,
    # but also can be set by calling the "getter" with an argument
    # and if called without an argument the getter will return the passed block
    #
    # Ex.
    # A.define_config_variable(:foo) { @foo || "hello" }
    # a = A.new
    # a.foo # returns "hello"
    # a.foo "foo"
    # a.foo # returns "foo"
    # a.foo = "bar"
    # a.foo # returns "bar"
    def self.define_config_variable(name, &block)
      attr_writer name

      define_method(name) do |*values|
        unless values.empty?
          self.send("#{name}=", values.first)
        else
          instance_eval(&block)
        end
      end
    end

    # the port the server will use, by default 4224
    define_config_variable(:port) { @port ||= 4224 }

    # the host of the server, by default localhost
    define_config_variable(:host) { @host ||= 'localhost' }

    # the whole server string - unless overwritten will be constructed from host and port,
    # if you specify server, host and port will be ignored
    # but you still need to specify port for starting the server
    define_config_variable(:server) { @server || "http://#{host}:#{port}" }

    # the base path to which all of the paths in the config file are relative
    define_config_variable(:base_path) { @base_path ||= '/' }

    def included_files
      @includes ||= []
    end

    def excluded_files
      @excludes ||= []
    end

    def html_fixtures
      @html_fixtures ||= []
    end

    def proxies
      @proxies ||= []
    end

    attr_writer :browsers

    def browsers
      @browsers ||= []
    end

    def to_s
      hash = {'server' => server, 'basepath' => base_path}
      hash['load'] = loaded_files unless loaded_files.empty?
      hash['exclude'] = map_paths(excluded_files) unless excluded_files.empty?
      hash['plugin'] = plugins unless plugins.empty?
      hash['proxy'] = proxies unless proxies.empty?
      return hash.to_yaml
    end

    # this is where the config files are saved (ex. RAILS_ROOT/.js_test_driver)
    def config_dir
      runtime_config.generated_files_dir
    end

    # this is where the config files are saved (ex. RAILS_ROOT/.js_test_driver/fixtures)
    def fixture_dir
      runtime_config.fixture_dir
    end

    def save
      File.open(runtime_config.config_yml_path, "w+") { |f| f.puts self.to_s }
      save_fixtures
      return self
    end

    private

    attr_reader :runtime_config

    def save_fixtures
      html_fixtures.each do |fixture|
        path = fixture_file_name(fixture)
        File.open(path, "w+") do |f|
          f.puts fixture.to_s
        end
      end
    end

    def fixture_file_name(fixture)
      File.join(fixture_dir, fixture.namespace, "#{fixture.name}.js")
    end

    def vendor_directory
      this_directory = File.dirname(__FILE__)
      return File.expand_path(File.join('..', '..', 'vendor'), this_directory)
    end

    def expand_globs(paths)
      with_expanded_paths = paths.map{|path| File.expand_path(path)}
      return with_expanded_paths.map{|path| path.include?('*') ? Dir[path].sort : path}.flatten
    end

    def loaded_files
      files = included_files + html_fixtures.collect { |fixture| fixture_file_name(fixture) }

      map_paths(files)
    end

    def path_relative_to_base_path(path)
      path.gsub(/^#{Regexp.escape(base_path)}/, '')
    end

    def map_paths(files)
      files.map{|file| path_relative_to_base_path(file)}
    end

    def attributes=(values)
      values.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end

    class Proxy
      attr_reader :pattern, :proxies

      def initialize(pattern, proxies)
        @pattern = pattern
        @proxies = proxies
      end

      def to(server)
        self.proxies << {'matcher' => pattern, 'server' => server}
      end
    end

  end
end
