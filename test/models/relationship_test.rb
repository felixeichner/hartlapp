require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
	def setup
		@relationship = Relationship.new(follower_id: users(:testname).id,
																		 followed_id: users(:archer).id)
	end

	test "should be valid" do
		assert @relationship.valid?
	end
	
	test "follower must be present" do
		@relationship.follower_id = nil
		assert_not @relationship.valid?
	end

	test "followed user must be present" do
		@relationship.followed_id = nil
		assert_not @relationship.valid?
	end
end
