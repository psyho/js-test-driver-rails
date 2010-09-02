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

    def test_config_with_browsers
      # given
      config = given_an_empty_config

      # when
      config.browser('firefox')
      config.browser('chrome')

      # then
      assert_equal ['firefox', 'chrome'], config.browsers
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
      assert_equal ['a', 'b', 'c'].map{|p| File.expand_path(p)}, config.included_files
      assert_equal [File.expand_path('d')], config.excluded_files
      assert_equal 'http://example.com:666', config.server
    end

    def test_given_a_config_path_should_expand_the_includes
      # given
      config = given_an_empty_config
      config.config_dir = "/foo/bbb/ccc"
      pwd = File.expand_path('.')
      config.includes "a/a", "/b/b", "../c"

      # then
      assert_config_includes config, 'load' => ["../../..#{pwd}/a/a", '../../../b/b', "../../..#{File.expand_path('../c')}"]
    end

    def test_config_with_html_fixtures
      # given
      config = given_an_empty_config
      config.config_dir = File.expand_path("configs")

      # when
      config.fixtures "fixture/directory", :name => "fixture_name", :namespace => "fixture_namespace"      

      # then
      assert_config_includes config, 'load' => ["fixtures/fixture_namespace/fixture_name.js"]
    end

    def test_should_save_fixtures
      # given
      config = given_an_empty_config
      config.config_dir = "tmp/stuff"
      config.fixtures fixture_dir, :name => "fixture_name", :namespace => "fixture_namespace"

      # when
      config.save_fixtures

      # then
      name = "tmp/stuff/fixtures/fixture_namespace/fixture_name.js"
      assert File.exists?(name)
      assert_equal File.read(name), config.html_fixtures.first.to_s
    ensure
      FileUtils.rm_rf("tmp/stuff")
    end

    def test_should_raise_argument_error_if_the_same_fixture_defined_twice
      # given
      config = given_an_empty_config
      config.fixtures "fixture/directory"

      assert_raises(ArgumentError) do
        config.fixtures "fixture/some_other_directory"
      end
    end

    def test_should_not_raise_argument_error_for_two_fixtures_with_different_names
      # given
      config = given_an_empty_config
      config.fixtures "fixture/directory"

      assert_nothing_raised do
        config.fixtures "fixture/some_other_directory", :name => "some_other_name"
      end
    end

    def test_enable_jasmine_adds_jasmine_and_jasmine_adapter
      # given
      config = given_an_empty_config

      # when
      config.enable_jasmine

      # then
      assert_equal 2, config.included_files.size
      assert File.exists?(config.included_files[0])
      assert Dir[config.included_files[1]].size > 0
    end

  end
end