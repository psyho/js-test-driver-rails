require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class RuntimeConfigTest < Test::Unit::TestCase

    attr_reader :runtime_config

    def test_should_have_default_config_path
      assert application.runtime_config.config_path
    end

    def test_should_have_default_jar_path
      assert application.runtime_config.jar_path
    end

    def test_should_have_default_tmp_path
      assert application.runtime_config.config_yml_path
    end

  end
end
