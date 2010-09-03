require File.expand_path(File.join(File.dirname(__FILE__), '..', 'js_test_driver'))

namespace :js_test_driver do

  desc "Starts the server using the provided configuration variables"
  task :start_server do
    JsTestDriver::Runner.new.start_server
  end

  desc "Runs the javascript tests"
  task :run_tests do
    exit(1) unless JsTestDriver::Runner.new.run_tests(ENV['TESTS'])
  end

  desc "Capture the browsers defined in config"
  task :capture_browsers do
    JsTestDriver::Runner.new.capture_browsers(ENV['BROWSERS'])
  end

  desc "Starts the server, captures the browsers, runs the tests - all at the same time"
  task :run do
    config = JsTestDriver::Runner.new
    output_path = ENV['OUTPUT_PATH']
    output_path = File.join(config.generated_files_dir, 'tests') if ENV['OUTPUT_XML']
    config.start_server_capture_and_run(ENV['TESTS'], ENV['BROWSERS'], output_path, ENV['CAPTURE_CONSOLE'])
  end

end