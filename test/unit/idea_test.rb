ENV['RACK_ENV'] = 'test'
require_relative '../helpers/idea_test_helper'

require_relative '../../lib/idea_box/idea'

class IdeaTest < Minitest::Test
  include Rack::Test::Methods

  attr_reader :new_idea

  def setup
    delete_test_db
    @new_idea = IdeaStore.create("title" => "app",
                                 "description" => "social network for penguins",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1,
                                 "tags" => "foo, bar, baz")
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def test_it_can_save_idea_to_db
    refute_equal 0, (IdeaStore.database.transaction {|db| db['ideas']}.length)
  end

  def test_it_can_be_destroyed
    IdeaStore.delete(0)
    assert_equal 0, (IdeaStore.database.transaction {|db| db['ideas']}.length)
  end

  def test_it_can_be_updated
    data = {
      "title" => "app",
      "description" => "new description penguins"
    }
    IdeaStore.update(0,data)
    assert_equal "new description penguins", (IdeaStore.database.transaction {|db| db['ideas'][0]})["description"]
    assert_equal "3", (IdeaStore.database.transaction {|db| db['ideas'][0]})["rank"]
    assert_equal 1, (IdeaStore.database.transaction {|db| db['ideas'][0]})["user_id"]
  end

  def test_it_can_be_liked
    prior_rank = IdeaStore.all.first.rank
    IdeaStore.all.first.like!
    assert prior_rank.to_i + 1, IdeaStore.all.first.rank.to_i
  end

  def test_it_responds_to_group_id
    assert_equal 1, IdeaStore.find(0).group_id
  end

  def test_it_returns_ideas_by_group_id
    second_idea = IdeaStore.create("title" => "boogie",
                                 "description" => "social network for penguins",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1)
    ideas = IdeaStore.find_all_by_group_id(1)
    assert_equal ["app","boogie"], ideas.map(&:title)
  end

  def test_it_assigns_and_returns_tags
    assert_equal ["foo","bar","baz"], IdeaStore.find(0).tags
  end

  def test_it_collects_all_tags
    second_idea = IdeaStore.create("title" => "boogie",
                                 "description" => "social network for penguins",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1,
                                 "tags" => "foo, fubar")
    assert_equal ["foo","bar","baz","fubar"], IdeaStore.all_tags
  end

  def test_it_returns_ideas_for_a_tag
     second_idea = IdeaStore.create("title" => "boogie",
                                 "description" => "social network for penguins",
                                 "rank" => "3",
                                 "user_id" => 1,
                                 "group_id" => 1,
                                 "tags" => "foo, fubar")
   assert_equal ["app","boogie"], IdeaStore.find_all_by_tag("foo").map(&:title)
  end

end
