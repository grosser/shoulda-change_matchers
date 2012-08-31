should_change / should_create / should_destroy matchers for shoulda 3 backported from shoulda 2<br/>
so you can upgrade to shoulda 3 without rewriting major parts of your test-base.

    gem install shoulda-change_matchers

    # Gemfile
    gem "shoulda-let", :require => "shoulda/change_matchers"

Usage
=====

<!-- example -->
    context "creating" do
      setup do
        User.create!
        User.create!
      end

      should_change("the number of users", :by => 2) { User.count }
    end

    context "doing nothing" do
      should_not_change("the number of users") { User.count }
    end

    context "creating" do
      setup{ User.create! }
      should_create :user
    end

    context "destroying" do
      setup{ User.delete_all }
      should_destroy :user
    end
<!-- example -->


Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://secure.travis-ci.org/grosser/shoulda_change_matchers.png)](http://travis-ci.org/grosser/shoulda_change_matchers)
