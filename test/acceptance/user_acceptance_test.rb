ENV['RACK_ENV'] = 'test'
require_relative '../helpers/acceptance_helper'
require 'pry'

class UserAcceptanceTest < Minitest::Test
  include Capybara::DSL

  attr_reader :first_user, :second_user

  def setup
    delete_test_db
    user1 = User.new("email" => "simon@example.com")
    user2 = User.new("email" => "geoff@example.com")
    @first_user = UserStore.create(user1)
    @second_user = UserStore.create(user2)
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def test_it_displays_email_addresses
    visit '/users'
    assert page.has_content?("simon@example.com")
    assert page.has_content?("geoff@example.com")
  end

  def test_it_can_create_a_new_user
    visit '/users'
    fill_in('user["email"]', :with => "Kumar@example.com")
    click_button('sign_up_button')
    assert page.has_content?("Kumar@example.com") #redirect /users
  end

  def test_it_goes_to_user_show_page
    skip
    # visit /users
    # click on show more for a user
    # page should show that users info, maybe check url?
  end

end
