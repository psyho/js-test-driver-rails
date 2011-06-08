module JsTestDriver

  class RemoteBrowser

    attr_reader :host, :browser, :driver

    def initialize(host, opts = {})
      @host = host
      @browser = opts[:browser]
    end

    def name
      ["remote-browser", host, browser].join('-') + '.rb'
    end

    def run(url)
      trap_signals

      opts = {:url => "http://#{host}/wd/hub"}
      opts[:desired_capabilities] = browser if browser

      @driver = Selenium::WebDriver.for(:remote, opts)
      driver.navigate.to url

      while(true) do
        sleep(1)
      end
    end

    def to_s
      jstd_dir = File.expand_path(File.join('..', '..'), __FILE__)
      <<RUBY
#!/usr/bin/env ruby

$:.push "#{jstd_dir}"

require "rubygems"
require "js_test_driver"

JsTestDriver::RemoteBrowser.new(#{host.inspect}, :browser => #{browser.inspect}).run(ARGV[0])
RUBY
    end

    private

    def trap_signals
      [:INT, :QUIT, :TERM].each do |sig|
        trap(sig) do
          driver.quit
          exit(0)
        end
      end
    end

  end

end
