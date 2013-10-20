ENV['RACK_ENV'] = 'test'
require_relative '../helpers/test_helper'

require_relative '../../lib/app'

class UserTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def setup
    delete_test_db
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def post_a_user
    post '/users', {:user => {:email => "bigTony@example.com"}}
  end

  def test_it_can_get_users_index
    get '/users'
    assert last_response.body.include?("Users")
  end

  def test_it_can_post_a_user
    post_a_user
    assert last_response.redirect?
    follow_redirect!
    assert last_response.body.include?("bigTony@example.com"), "after posting user, redirect back to user index"
  end

  def test_it_can_get_a_user_show_page
    post_a_user
    get '/users/2'
    assert last_response.ok?, "users/2 should respond with ok"
    assert last_response.body.include?("user page"), "user show page should include 'user page'"
    assert last_response.body.include?("bigTony@example.com"), "user show page should show the user's email"
  end

  def test_it_can_post_a_new_idea_from_user_show_page
    post_a_user
    post '/users/2', {:idea => {:title => "user 2 idea title", :description => "idea desc", :user_id => 2}}
    assert last_response.redirect?, "after posting idea, should redirect"
    follow_redirect!
    assert last_response.body.include?("bigTony@example.com"), "page should show user's email"
    assert last_response.body.include?("user 2 idea title"), "page should show new idea title"
  end

end
