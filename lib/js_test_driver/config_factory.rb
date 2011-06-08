module JsTestDriver
  class ConfigFactory

    attr_reader :runtime_config

    def initialize(runtime_config)
      @runtime_config = runtime_config
    end

    def new(opts = {})
      JsTestDriver::Config.new(runtime_config, opts)
    end

    def parse(string)
      config = new
      config.instance_eval(string)
      return config
    end

  end
end
