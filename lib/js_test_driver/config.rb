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

    # Adds a file to be loaded, the path *must* be relative to the yml config file (which is placed in the RAILS_ROOT
    # by default)
    #
    # JsTestDriver supports globbing
    def includes(*paths)
      paths.each do |path|
        self.included_files << path
      end
    end

    # Files specified here will not be loaded, it's useful when combined with globbing in includes 
    #
    # paths should be relative to RAILS_ROOT
    def excludes(*paths)
      paths.each do |path|
        self.excluded_files << path
      end
    end

    # Defines a browser to be captured by default
    #
    # This should be a string with no spaces (if you need to pass parameters to the browser you will
    # need to create a shell script ans put it's name here)
    def browser(browsers)
      browsers.each do |browser|
        self.browsers << browser
      end
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

    attr_writer :browsers

    def browsers
      @browsers ||= []
    end

    def to_s
      hash = {'server' => server}
      hash['load'] = included_files unless included_files.empty?
      hash['exclude'] = excluded_files unless excluded_files.empty?
      return hash.to_yaml
    end

    def self.parse(string)
      config = new
      config.instance_eval(string)
      return config
    end

    private

    def attributes=(values)
      values.each do |attr, value|
        self.send("#{attr}=", value)
      end
    end 

  end
end