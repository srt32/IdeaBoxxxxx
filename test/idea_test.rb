ENV['RACK_ENV'] = 'test'
require_relative './helpers/idea_test_helper'

require_relative '../lib/idea_box/idea'

class IdeaTest < Minitest::Test
  include Rack::Test::Methods

  attr_reader :new_idea

  def setup
    delete_test_db
    @new_idea = IdeaStore.create(title: "app", description: "social network for penguins", rank: "0")
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
      :idea_title => "app",
      :idea_description => "new description penguins"
    }
    IdeaStore.update(0,data)
    assert_equal "new description penguins", (IdeaStore.database.transaction {|db| db['ideas'][0]})[:idea_description]
  end

  def test_it_can_be_liked
    prior_rank = IdeaStore.all.first.rank
    IdeaStore.all.first.like!
    assert prior_rank+1, IdeaStore.all.first.rank.to_i
  end

end
