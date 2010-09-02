require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class HtmlFixtureTest < Test::Unit::TestCase

    def fixture_for_dir(dir)
      JsTestDriver::HtmlFixture.new(dir)
    end

    def test_given_a_made_up_fixture_directory_should_return_an_empty_hash
      # given
      fixture = fixture_for_dir('/xxx/yyy/zzz')

      # then
      assert_equal({}, fixture.to_h)
    end

    def file_contents(fixture_name)
      return File.read(File.join(fixture_dir, "#{fixture_name}.html"))
    end

    def known_fixtures
      %w{ a b c foo/a foo/bar/a baz/a }
    end

    def test_should_return_all_of_the_html_files_in_fixture_directory
      # given
      fixture = fixture_for_dir(fixture_dir)

      # then
      assert_equal known_fixtures.sort, fixture.to_h.keys.sort
    end

    def test_should_have_the_right_contents_for_every_fixture_file
      # given
      fixture = fixture_for_dir(fixture_dir)

      # then
      known_fixtures.each do |name|
        assert_equal file_contents(name), fixture.to_h[name], "The contents of the fixture '#{name}' differ"  
      end
    end

    def fixture_named(name, namespace)
      JsTestDriver::HtmlFixture.new('/some/bogus/directory', name, namespace)
    end

    def assert_contains(expected, actual)
      assert_not_nil actual
      assert actual.include?(expected), "Expected:\n#{actual}\nto include:\n#{expected}"
    end

    def test_should_initialize_the_namespace
      # given
      fixture = fixture_named('foo', 'ns')

      # then
      assert_contains "if (!ns) { ns = {}; }", fixture.to_s
    end

    def test_should_set_the_fixture
      # given
      fixture = fixture_named('foo', 'ns')

      # then
      assert_contains "ns.foo = {};", fixture.to_s
    end

  end
end