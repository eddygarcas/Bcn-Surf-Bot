require_relative 'msw_http_search'
require 'yaml'


class BotHelper

  @@config_yaml = YAML.load_file 'config/config.yml'

  def self.config
    @@config_yaml
  end

  def self.get(data = 'Barcelona')
    location = BotHelper.config[data.query.to_s.downcase]
    fields = BotHelper.config[:fields]
    MswHttpSearch.new.get_spot( location, fields)
  end


  def self.bot_markup
    kb = [[Telegram::Bot::Types::KeyboardButton.new(text: 'Start'), Telegram::Bot::Types::KeyboardButton.new(text: 'Help')]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup
    kb = chat_inline_location_markup
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end


  private


  def self.chat_inline_location_markup
    [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Barcelona', switch_inline_query_current_chat: 'Barcelona'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Sitges', switch_inline_query_current_chat: 'Sitges'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Masnou', switch_inline_query_current_chat: 'Masnou')]]
  end
end
