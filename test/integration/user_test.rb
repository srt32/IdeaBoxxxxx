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
    post '/', params={:idea => {:title => "yep", :description => "big idea"}}
  end

  def test_it_works
    assert false
  end

end
