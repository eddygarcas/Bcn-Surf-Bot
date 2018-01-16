require_relative 'msw_http_search'

class BotHelper

  @spots = { spotbarcelona: 3535, spotsitges: 3536, spotmasnou: 3530}

  def self.get(data = '3535')
    #The data.query.downcase would include Spot Barcelona(3535)/Sitges(3536)/Masnou(3530)
    MswHttpSearch.new.get_spot(data.query.to_i)
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
