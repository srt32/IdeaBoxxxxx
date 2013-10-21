require_relative '../helpers/acceptance_helper'

class GroupAcceptanceTest < Minitest::Test
  include Capybara::DSL

  attr_reader :first_reader,
              :second_user

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

  def test_it_can_create_a_new_group_for_the_user
    visit '/users/1'
    fill_in('group[name]', :with => "first_user's group")
    click_button('create_group_button')
    assert page.has_content?("first_user's group"), "should redirect to user#show page and display groups"
  end
end
