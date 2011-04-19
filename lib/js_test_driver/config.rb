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

    def initialize(attributes = {})
      self.attributes = attributes
    end

    # Adds a file to be loaded, the path *must* be relative to the root_dir (which is the current dir by default)
    #
    # JsTestDriver supports globbing
    def includes(*paths)
      paths.each do |path|
        self.included_files << File.expand_path(path)
      end
    end

    # Files specified here will not be loaded, it's useful when combined with globbing in includes
    #
    # paths should be relative to root_dir
    def excludes(*paths)
      paths.each do |path|
        self.excluded_files << File.expand_path(path)
      end
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
      this_directory = File.dirname(__FILE__)
      vendor_directory = File.expand_path(File.join('..', '..', 'vendor'), this_directory)
      includes File.join(vendor_directory, "jasmine", "lib", "jasmine.js")
      includes File.join(vendor_directory, "jasmine-jstd-adapter", "src", "*.js")
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

    def included_files
      @includes ||= []
    end

    def excluded_files
      @excludes ||= []
    end

    def html_fixtures
      @html_fixtures ||= []
    end

    attr_writer :browsers

    def browsers
      @browsers ||= []
    end

    def to_s
      hash = {'server' => server}
      hash['load'] = loaded_files unless loaded_files.empty?
      hash['exclude'] = map_paths(excluded_files) unless excluded_files.empty?
      return hash.to_yaml
    end

    def self.parse(string)
      config = new
      config.instance_eval(string)
      return config
    end

    attr_writer :config_dir

    # this is where the config files are saved (ex. RAILS_ROOT/.js_test_driver)
    def config_dir
      @config_dir ||= File.expand_path(".")
    end

    def save_fixtures
      html_fixtures.each do |fixture|
        path = fixture_file_name(fixture)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "w+") do |f|
          f.puts fixture.to_s
        end
      end
    end

    private

    def fixture_file_name(fixture)
      File.expand_path(File.join(config_dir, "fixtures", fixture.namespace, "#{fixture.name}.js"))
    end

    def loaded_files
      files = included_files + html_fixtures.collect { |fixture| fixture_file_name(fixture) }

      map_paths(files)
    end

    def path_relative_to_config_dir(path)
      source = File.expand_path(path).split(File::SEPARATOR)
      config = File.expand_path(config_dir).split(File::SEPARATOR)

      while source.first == config.first && !source.empty? && !config.empty?
        source.shift
        config.shift
      end

      parts = (['..'] * config.size) + source

      return File.join(*parts)
    end

    def map_paths(files)
      files.map{|file| path_relative_to_config_dir(file)}
    end

    def attributes=(values)
      values.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end

  end
end
