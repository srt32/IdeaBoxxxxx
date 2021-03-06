require_relative '../helpers/group_test_helper'
require_relative '../../lib/idea_box/group_store'

class GroupTest < Minitest::Test

  attr_reader :group_one, :saved_group

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

  def test_it_selects_only_groups_by_given_user
    group_two = Group.new(:name => "user.id 2 group", :user_id => 2)
    GroupStore.create(group_two)
    user_one_groups = GroupStore.find_all_by_user_id(1)
    assert_equal 1, user_one_groups.length
    assert_includes(user_one_groups.map(&:name),"best group")
    refute_includes(user_one_groups.map(&:name),"user.id 2 group")
  end

  def test_it_has_ideas
    first_idea = IdeaStore.create("title" => "app",
                                 "description" => "social network for penguins",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1)
    second_idea = IdeaStore.create("title" => "facebook",
                                 "description" => "social network for giraffes",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1)
    other_user_idea = IdeaStore.create("title" => "jungle",
                                 "description" => "board game",
                                 "rank" => "3",
                                 "user_id" => 2,
                                 "group_id" => 2)

    assert_equal ["app","facebook"], saved_group.last.ideas.map(&:title)
  end

end
