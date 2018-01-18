require_relative 'msw_http_search'
require 'yaml'


class BotHelper

  @@config_yaml = YAML.load_file 'config/config.yml'

  def self.config
    @@config_yaml
  end

  def self.get(data = '3535')
    base_uri = BotHelper.config[:key_api]
    location = BotHelper.config[data.query.to_i]
    MswHttpSearch.new.get_spot(data.query.to_i, location, base_uri)
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
    [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Barcelona', switch_inline_query_current_chat: '3535'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Sitges', switch_inline_query_current_chat: '3536'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Masnou', switch_inline_query_current_chat: '3530')]]
  end
end
