includes 'test/sample/lib/*.js'

['google-chrome', 'firefox', 'chromium-browser'].select{|b| !%x[which #{b}].strip.empty? }.each do |b|
  browser b
end

enable_jasmine

includes 'test/sample/specs/spec_helper.js'
includes 'test/sample/specs/**/*_spec.js'
