ENV['RACK_ENV'] = 'test'
require_relative '../helpers/acceptance_helper'
require 'pry'

class LoginAcceptanceTest < Minitest::Test
  include Capybara::DSL

  def test_it_gets_login_page
    visit '/login'
    assert_equal 404, page.status_code
  end

  def test_it_gets_logout_page
    visit '/logout'
    assert_equal 200, page.status_code
  end

end
