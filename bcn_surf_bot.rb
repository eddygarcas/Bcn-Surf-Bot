require 'telegram/bot'
require_relative 'helpers/bot_helper'
require_relative 'helpers/bot_message'



Telegram::Bot::Client.run(ENV[:BOT_API.to_s]) do |bot|
  bot.listen do |message|
    case message

      when Telegram::Bot::Types::InlineQuery
        items = []
        if BotHelper.action_spots?(message.query)
          items = BotHelper.get(message.query)
        end
        BotMessage.send_message(bot, message.id, items, true)

      when Telegram::Bot::Types::Message
        if message.venue && message.venue.location
          BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BOT_ACTION_MESSAGE)
        elsif message.location
          BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BOT_ACTION_MESSAGE)
        end

        case message.text
          when 'Help'
            BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BOT_HELP_MESSAGE)
          when 'Start' || '/start'
            BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup)
          else
            unless message.text.nil?
              BotMessage.send_bot_message(bot, message.chat.id, BotHelper.bot_markup, BOT_ERROR_MESSAGE)
            end
        end
    end
  end
end
