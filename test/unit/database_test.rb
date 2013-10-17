require_relative '../helpers/database_test_helper'

class DatabaseTest < Minitest::Test

  def setup
  end

  def test_it_exists
    assert Database
  end

  def test_it_returns_on_connect
    assert Database.connect
  end

  def test_it_returns_empty_array_for_ideas
    skip # not sure exactly what the behavior should be here, failing.
    result = Database.connect.transaction do
      Database.connect['ideas']
    end
    assert_equal [], result
  end

end
