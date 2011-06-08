host guess_local_ip

includes 'test/sample/lib/*.js'

['google-chrome', 'firefox', 'chromium-browser'].select{|b| !%x[which #{b}].strip.empty? }.each do |b|
  browser b
end

remote_browser '192.168.1.106:4444', :browser => :ie

enable_jasmine
measure_coverage

includes 'test/sample/specs/spec_helper.js'
includes 'test/sample/specs/**/*_spec.js'
