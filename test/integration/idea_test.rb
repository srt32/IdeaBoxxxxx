ENV['RACK_ENV'] = 'test'
require_relative '../helpers/test_helper'

require_relative '../../lib/app'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def post_an_idea
    # TODO: change this to post to /users/1
    post '/', params={:idea => {:title => "yep",
                                :description => "big idea",
                                :user_id => 1,
                                :group_id => 1,
                                :tags => "foo, bar, baz"}}
  end

  def test_it_routes_to_root_post
    skip # deprecated, now posts to /users/:id
    post_an_idea
    assert last_response.redirect?
    follow_redirect!
    assert last_response.body.include?("yep"), "Index should include 'yep'"
    assert last_response.body.include?("foohdhdhd"), "index should contain a tag"
  end

  def test_it_can_delete_an_idea
    post_an_idea
    delete '/0'
    assert last_response.redirect?, "route was not redirected"
    #assert this record doesn't exist anymore
  end

  def test_it_can_route_to_idea_it_put
    post_an_idea
    put '/0', params={:idea => {:idea_title => "updated title", :idea_description => "updated description", :group_id => 2}}
    assert last_response.redirect?, "route was not redirected"
  end

  def test_it_can_route_to_rank_with_post
    post_an_idea
    post '/0/like'
    assert last_response.redirect?, "route was not redirected"
  end

  def make_ideas_with_tags(amount)
    titles = ["big idea", "foofoo", "big dingo"]
    tags = ["foo", "foo", "bar"]
    for i in 0..(amount-1) do
      count = i
      IdeaStore.create("title" => titles[i],
                                 "description" => "social network for penguins",
                                 "rank" => 3,
                                 "user_id" => 1,
                                 "group_id" => 1,
                                 "tags" => tags[i])
      count += 1
    end
  end

  def test_it_generates_tag_routes
    make_ideas_with_tags(3)
    get '/tags/foo'
    assert last_response.ok?, "page should be okay"
  end

end
