require_relative '../helpers/group_test_helper'

class GroupTest < Minitest::Test

  attr_reader :group_one

  def setup
    @group_one = Group.new(:name => "best group", :user_id => 1)
  end

  def test_it_accepts_and_responds_to_name_and_user_id
    assert_equal "best group", group_one.name
    assert_equal 1, group_one.user_id
    assert_nil group_one.id, "id should be nil until saved by GroupStore"
  end

end
