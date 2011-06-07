require 'json'
require 'fileutils'

module JsTestDriver
  autoload :Application, 'js_test_driver/application'
  autoload :Config, 'js_test_driver/config'
  autoload :HtmlFixture, 'js_test_driver/html_fixture'
  autoload :MissingDependencyError, 'js_test_driver/missing_dependency_error'
  autoload :Runner, 'js_test_driver/runner'
  autoload :RuntimeConfig, 'js_test_driver/runtime_config'
  autoload :VERSION, 'js_test_driver/version'

  module CLI
    autoload :CaptureBrowsers, 'js_test_driver/cli/capture_browsers'
    autoload :Run, 'js_test_driver/cli/run'
    autoload :RunTests, 'js_test_driver/cli/run_tests'
    autoload :StartServer, 'js_test_driver/cli/start_server'
  end

  module Commands
    autoload :BaseCommand, 'js_test_driver/commands/base_command'
    autoload :GenerateCoverageReport, 'js_test_driver/commands/generate_coverage_report'
    autoload :JstdJarCommand, 'js_test_driver/commands/jstd_jar_command'
  end
end
