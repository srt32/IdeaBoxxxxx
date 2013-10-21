require_relative '../helpers/group_test_helper'
require_relative '../../lib/idea_box/group_store'

class GroupTest < Minitest::Test

  attr_reader :group_one

  def setup
    delete_test_db
    @group_one = Group.new(:name => "best group", :user_id => 1)
    @saved_group = GroupStore.create(@group_one)
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def test_it_accepts_and_responds_to_name_and_user_id
    assert_equal "best group", group_one.name
    assert_equal 1, group_one.user_id
  end

  def test_it_responds_to_all_attribs_from_db
    stored_group = GroupStore.all.first
    assert_equal "best group", stored_group.name
    assert_equal 1, stored_group.user_id
    assert_equal 1, stored_group.id
  end

  def test_it_gets_serialized_ids
    group_two = Group.new(:name => "second best group", :user_id => 1)
    GroupStore.create(group_two)
    assert_equal 1, GroupStore.all.first.id
    assert_equal 2, GroupStore.all[1].id
  end

end
