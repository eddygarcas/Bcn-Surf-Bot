require 'telegram/bot'
require_relative 'helpers/bot_helper'
require_relative 'helpers/bot_message'



TELEGRAM_BOT_TOKEN = '520728214:AAE9yOWbX6p2J2v3G7Q5cWRECvhgsWSGO6Q' #ENV['TELEGRAM_BOT_TOKEN']


Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  bot.listen do |message|
    case message
      when Telegram::Bot::Types::CallbackQuery
        surfSpot = BotHelper.get(message.data)
        BotMessage.send_message(bot, message.from.id, surfSpot)

      when Telegram::Bot::Types::InlineQuery
        surfspot = BotHelper.get(message)
        BotMessage.send_message(bot, message.id, surfspot, true)

      when Telegram::Bot::Types::Message
        if message.venue && message.venue.location
          BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BOT_ACTION_MESSAGE)
        elsif message.location
          BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup(message.location), BOT_ACTION_MESSAGE)
        end

        case message.text
          when 'Help'
            BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BOT_HELP_MESSAGE)
          when 'Start' || '/start'
            BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup)
          else
            unless (message.text.nil? || message.text.start_with?('At'))
              BotMessage.send_bot_message(bot, message.chat.id, BotHelper.bot_markup, BOT_ERROR_MESSAGE)
            end
        end
    end
  end
end
