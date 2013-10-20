ENV['RACK_ENV'] = 'test'
require_relative '../helpers/test_helper'

require_relative '../../lib/app'

class UserTest < Minitest::Test
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
    get '/users/1'
    assert last_response.ok?, "users/1 should respond with ok"
    assert last_response.body.include?("bigTony@exampl.com"), "user show page should show the user's email"
  end

end
