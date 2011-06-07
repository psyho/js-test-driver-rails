require 'rubygems'
require 'bundler'

Bundler.setup

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'js_test_driver'))

require 'test/unit'
require 'mocha'

class FakeRunner

  attr_reader :commands_run, :commands_run_in_bg

  def initialize
    @commands_run = []
    @commands_run_in_bg = []
  end

  def run(command)
    @commands_run << command.to_s
  end

  def runbg(command)
    @commands_run_in_bg << command.to_s
  end

  def has_run?(command)
    @commands_run.include?(command.to_s)
  end

  def has_run_in_bg?(command)
    @commands_run_in_bg.include?(command.to_s)
  end
end

class Test::Unit::TestCase

  attr_reader :application, :runner

  def setup
    @application = JsTestDriver::Application.new
    @runner = FakeRunner.new
    @application.stubs(:runner => @runner)
    clean_up_saved_config_files
  end

  def fixture_dir
    File.expand_path('fixtures', File.dirname(__FILE__))
  end

  def config
    application.config
  end

  def runtime_config
    application.runtime_config
  end

  def assert_run(cmd)
    assert runner.has_run?(cmd), "Expected to have run:\n#{cmd}\nbut only commands run were:\n#{runner.commands_run.join("\n")}"
  end

  def assert_run_in_bg(cmd)
    assert runner.has_run_in_bg?(cmd), "Expected to have run in bg:\n#{cmd}\nbut only commands run were:\n#{runner.commands_run_in_bg.join("\n")}"
  end

  def clean_up_saved_config_files
    root_dir = File.expand_path('..', File.dirname(__FILE__))
    Dir["#{root_dir}/**/.js_test_driver"].each do |file|
      FileUtils.rm_rf(file)
    end
  end

end
