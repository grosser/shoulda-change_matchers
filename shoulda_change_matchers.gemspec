$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "shoulda_change_matchers"
require "#{name}/version"

Gem::Specification.new name, ShouldaChangeMatchers::VERSION do |s|
  s.summary = "should_change / should_create / should_destroy matchers for shoulda 3 backported from shoulda 2"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
