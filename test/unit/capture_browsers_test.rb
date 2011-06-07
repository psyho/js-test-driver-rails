require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

module JsTestDriver
  class CaptureBrowsersTest < Test::Unit::TestCase

    def test_should_capture_default_browsers
      config.browser 'foo', 'bar', 'baz'
      JsTestDriver::Commands::BaseCommand.any_instance.stubs(:ensure_installed!)

      application.capture_browsers

      ['foo', 'bar', 'baz'].each do |browser|
        assert_run_in_bg("#{browser} http://localhost:4224/capture?strict")
      end
    end

    def test_should_capture_given_browsers
      config.browser 'foo', 'bar', 'baz'
      JsTestDriver::Commands::BaseCommand.any_instance.stubs(:ensure_installed!)

      application.capture_browsers(:browsers => 'aaa,bbb')

      ['aaa', 'bbb'].each do |browser|
        assert_run_in_bg("#{browser} http://localhost:4224/capture?strict")
      end
    end

  end
end

