require_relative 'msw_http_search'
require_relative 'config_helper'

class BotHelper < ConfigHelper

  def self.get(data = 'Barcelona')
    location = config(:spots)[data.to_s.downcase]
    fields = config(:fields)
    MswHttpSearch.new.get_spot( location, fields)
  end

  def self.bot_markup
    kb = [[Telegram::Bot::Types::KeyboardButton.new(text: 'Start'), Telegram::Bot::Types::KeyboardButton.new(text: 'Help')]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup
    kb = []
    kb << inline_spots_markup
    #kb << inline_actions_markup
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def self.action_spots? (query)
    config(:actions)[:spots].include?(query.to_s.downcase)
  end

  private


  def self.inline_spots_markup
    keyboard_spots = []
    config(:spots).each { |elem|
      keyboard_spots << self.inline_button(elem.first)
    }
    keyboard_spots
  end

  def self.inline_actions_markup
    actions_markup = []
    actions_markup << self.inline_button('Set height (m)')
  end

  def self.inline_button(item)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: item.capitalize, switch_inline_query_current_chat: item.capitalize)
  end

end
