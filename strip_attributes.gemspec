lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.platform       = Gem::Platform::RUBY
  s.name           = 'strip_attributes'
  s.version        = '1.0.0'
  s.licenses       = ['MIT']
  s.summary     = "Whitespace cleanup for ActiveModel attributes"
  s.description = "StripAttributes automatically strips all ActiveRecord model attributes of leading and trailing whitespace before validation. If the attribute is blank, it strips the value to nil."
  s.authors        = ["Ryan McGeary", "Vladimir Bedarev"]
  s.files          = `git ls-files -- {app,bin,lib,test,spec}/* {LICENSE*,Rakefile,README*}`.split("\n")
  s.test_files     = `git ls-files -- {test,spec}/*`.split("\n")
  s.require_paths  = ["lib"]

  s.add_runtime_dependency 'activemodel', '>= 3.2', '< 6.1'
  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'virtus'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit'
end
