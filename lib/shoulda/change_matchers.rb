module Shoulda
  module ChangeMatchers
    # Macro that creates a test asserting a change between the return value
    # of a block that is run before and after the current setup block
    # is run. This is similar to Active Support's <tt>assert_difference</tt>
    # assertion, but supports more than just numeric values.  See also
    # should_not_change.
    #
    # The passed description will be used when generating the test name and failure messages.
    #
    # Example:
    #
    #   context "Creating a post" do
    #     setup { Post.create }
    #     should_change("the number of posts", :by => 1) { Post.count }
    #   end
    #
    # As shown in this example, the <tt>:by</tt> option expects a numeric
    # difference between the before and after values of the expression.  You
    # may also specify <tt>:from</tt> and <tt>:to</tt> options:
    #
    #   should_change("the number of posts", :from => 0, :to => 1) { Post.count }
    #   should_change("the post title", :from => "old", :to => "new") { @post.title }
    #
    # Combinations of <tt>:by</tt>, <tt>:from</tt>, and <tt>:to</tt> are allowed:
    #
    #   # Assert the value changed in some way:
    #   should_change("the post title") { @post.title }
    #
    #   # Assert the value changed to anything other than "old:"
    #   should_change("the post title", :from => "old") { @post.title }
    #
    #   # Assert the value changed to "new:"
    #   should_change("the post title", :to => "new") { @post.title }
    #
    # This macro was deprecated because these tests aren't as valuable as
    # alternative tests that explicitly test the final state.
    #
    # Consider an alternative:
    #
    #   context "updating a post" do
    #     setup do
    #       @post = Post.create(:title => "old")
    #       put :update, :post => {:title => "new"}, :id => @post.to_param
    #     end
    #     should "update the title" do
    #       assert_equal "new", @post.reload.title
    #     end
    #   end
    def should_change(description, options = {}, &block)
      by, from, to = shoulda_get_options!([options], :by, :from, :to)
      stmt = "change #{description}"
      stmt << " from #{from.inspect}" if from
      stmt << " to #{to.inspect}" if to
      stmt << " by #{by.inspect}" if by

      before = lambda { @_before_should_change = instance_eval(&block) }
      should stmt, :before => before do
        old_value = @_before_should_change
        new_value = instance_eval(&block)
        assert_operator from, :===, old_value, "#{description} did not originally match #{from.inspect}" if from
        assert_not_equal old_value, new_value, "#{description} did not change" unless by == 0
        assert_operator to, :===, new_value, "#{description} was not changed to match #{to.inspect}" if to
        assert_equal old_value + by, new_value if by
      end
    end

    # Deprecated.
    #
    # Macro that creates a test asserting no change between the return value
    # of a block that is run before and after the current setup block
    # is run. This is the logical opposite of should_change.
    #
    # The passed description will be used when generating the test name and failure message.
    #
    # Example:
    #
    #   context "Updating a post" do
    #     setup { @post.update_attributes(:title => "new") }
    #     should_not_change("the number of posts") { Post.count }
    #   end
    #
    # This macro was deprecated because these tests aren't as valuable as
    # alternative tests that explicitly test the final state.
    #
    # Consider an alternative:
    #
    #   context "updating a post" do
    #     setup do
    #       @post = Post.create(:title => "old")
    #       put :update, :post => {:title => ""}, :id => @post.to_param
    #     end
    #     should "not update the title" do
    #       assert_equal "old", @post.reload.title
    #     end
    #   end
    def should_not_change(description, &block)
      before = lambda { @_before_should_not_change = instance_eval(&block) }
      should "not change #{description}", :before => before do
        new_value = instance_eval(&block)
        error_message = "#{description} changed"
        if @_before_should_not_change.nil?
          assert_nil new_value, error_message
        else
          assert_equal @_before_should_not_change, new_value, error_message
        end
      end
    end

    # Deprecated.
    #
    # Macro that creates a test asserting that a record of the given class was
    # created.
    #
    # Example:
    #
    #   context "creating a post" do
    #     setup { Post.create(post_attributes) }
    #     should_create :post
    #   end
    def should_create(class_name)
      should_change_record_count_of(class_name, 1, 'create')
    end

    # Deprecated.
    #
    # Macro that creates a test asserting that a record of the given class was
    # destroyed.
    #
    # Example:
    #
    #   context "destroying a post" do
    #     setup { Post.first.destroy }
    #     should_destroy :post
    #   end
    def should_destroy(class_name)
      should_change_record_count_of(class_name, -1, 'destroy')
    end

    private

    def should_change_record_count_of(class_name, amount, action) # :nodoc:
      klass = class_name.to_s.camelize.constantize
      before = lambda do
        @_before_change_record_count = klass.count
      end
      human_name = class_name.to_s.humanize.downcase
      should "#{action} a #{human_name}", :before => before do
        assert_equal @_before_change_record_count + amount,
          klass.count,
          "Expected to #{action} a #{human_name}"
      end
    end

    # Returns the values for the entries in the args hash who's keys are listed in the wanted array.
    # Will raise if there are keys in the args hash that aren't listed.
    def shoulda_get_options!(args, *wanted)
      ret  = []
      opts = (args.last.is_a?(Hash) ? args.pop : {})
      wanted.each {|w| ret << opts.delete(w)}
      raise ArgumentError, "Unsupported options given: #{opts.keys.join(', ')}" unless opts.keys.empty?
      return wanted.size == 1 ? ret.first : ret
    end
  end
end

klass = (defined?(MiniTest::Unit::TestCase) ? MiniTest::Unit::TestCase : Test::Unit::TestCase)
klass.send :extend, Shoulda::ChangeMatchers
