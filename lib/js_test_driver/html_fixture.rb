module JsTestDriver
  # This is a class that given a directory name, puts all its *.html children
  # into a javascript file, so that they can later be used in the tests
  class HtmlFixture

    attr_reader :name, :namespace

    def initialize(directory_name, name = nil, namespace = nil)
      @name = name || "all"
      @namespace = namespace || "htmlFixtures"
      @data = {}

      load_data(directory_name)
    end

    def to_h
      @data
    end

    def to_s
      <<JS
if (typeof(#{namespace}) === 'undefined') { #{namespace} = {}; }
#{namespace}.#{name} = #{MultiJson.encode(self.to_h)};
JS
    end

    private

    def load_data(directory_name)
      full_path = File.expand_path(directory_name)
      files = Dir["#{full_path}/**/*.html"]

      files.each do |file|
        name = file.gsub(/^#{full_path}\//, '').gsub(/\.html$/, '')
        @data[name] = File.read(file)
      end
    end

  end
end
