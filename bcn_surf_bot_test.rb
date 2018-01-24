require 'test/unit'
require 'telegram/bot'
require_relative 'helpers/msw_http_search'
require_relative 'helpers/bot_helper'
require_relative 'helpers/bot_message'

class BcnSurfBotTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @@config = YAML.load_file 'config/config.yml'
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_actions
    assert_true(BotHelper.action_spots?(:barcelona.to_s))
  end

  def test_get_barcelona_spot
    location = @@config[:spots][:barcelona.to_s]
    spot = MswHttpSearch.new.get_spot(location,@@config[:fields])
    spot.each { |elem| pp elem.to_s}
    assert_not_nil(spot.to_s)
  end

  def test_get_barcelona_spot_form_helper
    spot = BotHelper.get
    spot.each { |elem| pp elem.to_s}
    assert_not_nil(spot.to_s)
  end

  def test_inline_result_from_bot_message
    spot = BotHelper.get
    BotMessage.inline_result(spot).each { |elem|
      pp elem.to_s
    }
  end

  def test_inline_result_from_empty_array
    elem = BotMessage.inline_result([])
    assert_empty(elem)
    pp elem
  end

  def test_get_404_error_code
    assert_raise ArgumentError do
      MswHttpSearch.new.get_spot(nil,@@config[:fields])
    end
  end


end