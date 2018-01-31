require_relative 'msw_http_search'
require_relative 'config_helper'

class BotHelper < ConfigHelper

  def self.get(data = 'Barcelona')
    location = config(:spots)[data.to_s.downcase]
    fields = config(:fields)
    MswHttpSearch.new.get_spot(location, fields)
  end

  def self.bot_markup
    kb = [[Telegram::Bot::Types::KeyboardButton.new(text: 'Start'), Telegram::Bot::Types::KeyboardButton.new(text: 'Help')]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_spots_markup)
  end

  private

  def self.inline_spots_markup
    keyboard_spots = Array.new(2) { Array.new }
    count = 0
    config(:spots).each{ |elem|
      if ((count += 1) <= 3)
        keyboard_spots.first << self.inline_button(elem.first)
      else
        keyboard_spots[1] << self.inline_button(elem.first)
      end

    }
    keyboard_spots
  end

  def self.inline_button(item)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: item.capitalize, switch_inline_query_current_chat: item.capitalize)
  end

end
