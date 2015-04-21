require "bundler/setup"

BASE_CLASS = begin
  gem "test-unit"
  require "test/unit"
  raise if ENV["BUNDLE_GEMFILE"].include?("minitest") # sanity check
  Test::Unit::TestCase
rescue LoadError
  gem "minitest"
  require "minitest/autorun"
  MiniTest::Unit::TestCase.class_eval do
    alias assert_not_equal refute_equal
  end
  MiniTest::Unit::TestCase
end

require "shoulda"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "shoulda/change_matchers"

# simulate active_support being here ...
class String
  def camelize
    "User"
  end

  def constantize
    eval self
  end

  def humanize
    camelize
  end
end

class User
  class << self
    attr_accessor :count

    def create!
      self.count += 1
    end

    def delete_all
      self.count = 0
    end
  end
end

class ShouldaLetTest < BASE_CLASS
  context "test" do
    setup do
      User.count = 1
    end

    context "Readme" do
      example = File.read(File.expand_path("../../Readme.md", __FILE__)).match(/<!-- example -->(.*)<!-- example -->/m)[1]
      eval example
    end
  end
end
