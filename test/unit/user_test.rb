ENV['RACK_ENV'] = 'test'
require_relative '../helpers/user_test_helper'

require_relative '../../lib/idea_box/user'

class UserTest < Minitest::Test

  attr_reader :user, :new_user

  def setup
    delete_test_db
    @user = User.new("email" => "simon@example.com")
    @new_user = UserStore.create(user)
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def test_it_can_save_to_db
    refute_equal 0, (UserStore.database.transaction {|db| db['users']}.length)
  end

  def test_it_responds_to_email_from_user_object
    assert_equal "simon@example.com", user.email
  end

  def test_it_responds_to_email_from_db
    assert_equal "simon@example.com", UserStore.all.first.email
  end

  def test_it_responds_to_id_from_user_object
    assert_equal 1, user.id
  end

  def test_it_can_find_a_user
    first_user = UserStore.find(1)
    assert_equal "simon@example.com", first_user.email
    assert_equal 1, first_user.id
  end

  def test_it_can_find_largest_id
    assert_equal 1, UserStore.max_id
    second_user = User.new("email" => "simon@example.com")
    UserStore.create(second_user)
    assert_equal 2, UserStore.max_id
  end

  def test_it_responds_to_id_from_db
    assert_equal 1, UserStore.all.first.id
    second_user = User.new("email" => "simon@example.com")
    UserStore.create(second_user)
    assert_equal 2, UserStore.all[1].id
  end

  def test_it_can_be_destroyed
    second_user = User.new("email" => "gary@example.com")
    UserStore.create(second_user)
    third_user = User.new("email" => "busse@example.com")
    UserStore.create(third_user)
    assert_equal 3, UserStore.all.count
    UserStore.delete(2)
    assert_equal [1,3], UserStore.all.map(&:id)
  end

  def test_it_can_be_updated
    new_data = {"email" => "simonsays@example.com"}
    UserStore.update(0,new_data)
    assert_equal "simonsays@example.com", UserStore.all.first.email
  end

end
