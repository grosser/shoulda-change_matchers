name = "shoulda-change_matchers"

Gem::Specification.new name, "0.0.1" do |s|
  s.summary = "should_change / should_create / should_destroy matchers for shoulda 3 backported from shoulda 2"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
