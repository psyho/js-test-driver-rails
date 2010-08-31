module JsTestDriver
  class Config

    def included_files
      @includes ||= []
    end

    def includes(*paths)
      paths.each do |path|
        self.included_files << path
      end
    end

    def excluded_files
      @excludes ||= []
    end

    def excludes(*paths)
      paths.each do |path|
        self.excluded_files << path
      end
    end

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

    define_config_variable(:port) { @port ||= 4224 }
    define_config_variable(:host) { @host ||= 'localhost' }
    define_config_variable(:server) { @server || "http://#{host}:#{port}" }

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

  end
end