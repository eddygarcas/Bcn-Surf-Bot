require 'test/unit'
require_relative 'helpers/msw_http_search'

class BcnSurfBotTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_get_barcelona_spot

    spot = MswHttpSearch.new.get_spot(3535)
    assert_not_nil(spot)

  end

  def test_get_404_error_code
    assert_raise StandardError do
      MswHttpSearch.new.get_spot(nil)
    end
  end
end