require "spec_helper"

describe ShouldaChangeMatchers do
  it "has a VERSION" do
    ShouldaChangeMatchers::VERSION.should =~ /^[\.\da-z]+$/
  end
end
