name = "shoulda-change_matchers"

Gem::Specification.new name, "0.0.2" do |s|
  s.summary = "should_change / should_create / should_destroy matchers for shoulda 3 backported from shoulda 2"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib`.split("\n")
  s.license = "MIT"
  s.add_development_dependency "rake"
  s.add_development_dependency "bump"
  s.add_development_dependency "wwtd"
  s.add_development_dependency "shoulda"
end
