ENV['RACK_ENV'] = 'test'
require_relative '../helpers/acceptance_helper'
require 'pry'

class IdeaAcceptanceTest < Minitest::Test
  include Capybara::DSL

  attr_reader :first_user

  def setup
    delete_test_db
    user1 = User.new("email" => "boom@example.com")
    @first_user = UserStore.create(user1)
    @new_idea = IdeaStore.create("title" => "app",
                                 "description" => "social network for penguins",
                                 "rank" => 3,
                                 "user_id" => 1,
                                 "group_id" => 1)

    make_groups
  end

  def teardown
    delete_test_db
  end

  def delete_test_db
    File.delete('./ideabox_test') if File.exists?('./ideabox_test')
  end

  def test_it_doesnt_break
    visit '/'
    assert_equal 200, page.status_code
  end

  def test_it_can_edit_an_idea
    visit '/'
    click_link('Edit')
    fill_in('idea[title]', :with => "NOPE")
    click_button('submit_button')
    assert page.has_content?('NOPE')
  end

  def test_it_can_delete_an_idea
    visit '/'
    assert page.has_content?('penguin')
    click_button('delete')
    refute page.has_content?('penguin')
  end

  def test_it_can_add_to_rank
    visit '/'
    assert page.has_content?("3")
    click_button('+')
    assert page.has_content?("4")
  end

  def test_it_can_post_to_a_specific_user_and_group
    visit '/users/1'
    fill_in('idea[title]', :with => "pushups")
    fill_in('idea[description]', :with => "100's")
    find(:select, "idea[group_id]").first(:option, 'user_1_first_group').select_option
    click_button('submit_button')
    assert page.has_content?("pushups")
  end

  def make_groups
    @group_one = GroupStore.create(Group.new(:name => "user_1_first_group", :user_id => 1))
    @group_two = GroupStore.create(Group.new(:name => "user_1_second_group", :user_id => 1))
    @group_three = GroupStore.create(Group.new(:name => "user_2_first_group", :user_id => 2))
  end

end
