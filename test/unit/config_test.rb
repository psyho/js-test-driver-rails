require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class ConfigTest < Test::Unit::TestCase

    def default_result
      {'server' => 'http://localhost:4224'}
    end

    def assert_config_includes(config, hash)
      expected = default_result.merge(hash)
      assert_equal expected, YAML::load(config.to_s)
    end

    def given_an_empty_config
      JsTestDriver::Config.new  
    end

    def test_empty_config
      # given
      config = given_an_empty_config

      # then
      assert_config_includes(config, default_result)
    end

    def test_custom_port
      # given
      config = given_an_empty_config

      # when
      config.port 666

      # then
      assert_config_includes config, 'server' => 'http://localhost:666'
    end

    def test_custom_host
      # given
      config = given_an_empty_config

      # when
      config.host 'example.com'

      # then
      assert_config_includes config, 'server' => 'http://example.com:4224'
    end

    def test_custom_server
      # given
      config = given_an_empty_config

      # when
      config.server 'https://example.com:443'

      # then
      assert_config_includes config, 'server' => 'https://example.com:443'
    end

    def test_server_should_override_host_and_port
      # given
      config = given_an_empty_config

      # when
      config.port 666
      config.host 'test.com'
      config.server 'https://example.com:443'

      # then
      assert_config_includes config, 'server' => 'https://example.com:443'
    end

    def test_config_with_includes
      # given
      config = given_an_empty_config

      # when
      config.includes('src/*.js')

      # then
      assert_config_includes config, 'load' => ['src/*.js']
    end

    def test_config_with_multiple_includes
      # given
      config = given_an_empty_config

      # when
      ['a', 'b', 'c'].each do |name|
        config.includes(name)
      end

      # then
      assert_config_includes config, 'load' => ['a', 'b', 'c']
    end

    def test_config_with_excludes
      # given
      config = given_an_empty_config

      # when
      config.excludes('src/*.js')

      # then
      assert_config_includes config, 'exclude' => ['src/*.js']
    end

    def test_empty_config_file
      # given
      str = ""

      # when
      config = JsTestDriver::Config.parse(str)

      # then
      assert_equal [], config.included_files
      assert_equal [], config.excluded_files
      assert_equal "http://localhost:4224", config.server
    end

    def test_sample_config_file
      # given
      str = <<-CONFIG
      includes 'a', 'b'
      includes 'c'

      excludes 'd'

      server 'http://example.com:666'
      CONFIG

      # when
      config = JsTestDriver::Config.parse(str)

      # then
      assert_equal ['a', 'b', 'c'], config.included_files
      assert_equal ['d'], config.excluded_files
      assert_equal 'http://example.com:666', config.server
    end

  end
end