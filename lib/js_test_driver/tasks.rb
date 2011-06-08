require File.expand_path(File.join(File.dirname(__FILE__), '..', 'js_test_driver'))

namespace :js_test_driver do

  desc "Starts the server using the provided configuration variables"
  task :start_server do
    JsTestDriver::Application.new.start_server
  end

  desc "Runs the javascript tests"
  task :run_tests do
    exit(1) unless JsTestDriver::Application.new.run_tests(:tests => ENV['TESTS'])
  end

  desc "Capture the browsers defined in config"
  task :capture_browsers do
    JsTestDriver::Application.new.capture_browsers(:browsers => ENV['BROWSERS'])
  end

  desc "Starts the server, captures the browsers, runs the tests - all at the same time"
  task :run do
    app = JsTestDriver::Application.new

    exit(1) unless app.run(:tests => ENV['TESTS'],
                           :browsers => ENV['BROWSERS'],
                           :output_xml => !!ENV['OUTPUT_XML'],
                           :capture_console => ENV['CAPTURE_CONSOLE'])
  end

end
