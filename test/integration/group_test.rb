require_relative '../helpers/test_helper'
require_relative '../../lib/app'

class GroupIntegrationTest < Minitest::Test
  include Rack::Test::Methods

  attr_reader :new_user

  def app
    IdeaBoxApp
  end

  def setup
    delete_test_db
    user = User.new("email" => "simon@example.com")
    @new_user = UserStore.create(user)
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def post_a_group
    post '/users/1/groups', {:group => {:name => "baptists", :user_id => 1}}
  end

  def test_it_can_get_users_page_with_groups
    post_a_group
    get '/users/1'
    assert last_response.ok?, "groups page should not explode"
    assert last_response.body.include?("baptists"), "baptists group should be included on user show page"
  end
  #next move to acceptance test to drive creation of the group#create form

end
