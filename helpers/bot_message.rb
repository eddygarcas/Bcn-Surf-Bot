START_BOT_MESSAGE = "Thanks for using BcnSurfForecast Bot.\nThis bot will provide surf forecast from spots nearby Barcelona.\nSelect one spot..."

BOT_ERROR_MESSAGE = "Oops! Something went wrong, please press /start button again."

BOT_HELP_MESSAGE = "Use inline buttons below here, or type the inline command @bcnsurfbot in any chat to find out the forecast.\n"

BOT_ACTION_MESSAGE = "Select one spot..."

class BotMessage


  def self.send_bot_message(bot, chatId, markup, text = nil)
    if text.nil?
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{START_BOT_MESSAGE}},
                           reply_markup: markup)
    else
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{text}},
                           reply_markup: markup)
    end
  end

  def self.send_message(bot, chatId, item = nil, inline = false)
    if item.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{#{BOT_ERROR_MESSAGE}})
    else
      send_location(bot, chatId, item, inline)
    end
  end


  protected

  def self.send_location(bot, chatId, item, inline = false)
    if inline
      send_inline_location(bot, chatId, item)
    else
      send_callback_location(bot, chatId, item)
    end

  end

  private

  def self.send_inline_location(bot, chatId, item)
    bot.api.answer_inline_query(
        inline_query_id: chatId,
        results: inline_result(item)
    )
  end

  def self.send_callback_location(bot, chatId, item)
    bot.api.send_venue(chat_id: chatId,
                       latitude: item.latitude,
                       longitude: item.longitude,
                       title: item.name,
                       address: item.to_string
    )
  end

  def self.inline_result(item)
    result = []
    if arr = Array.try_convert(item)
      count = 0
      result = arr.map {|elem| create_inline_result(elem, count+=1)}
    else
      result << create_inline_result(item)
    end
    return result
  end

  def self.create_inline_result(item, count = 1)
    Telegram::Bot::Types::InlineQueryResultLocation.new(
        id: count.to_s,
        latitude: item.latitude,
        longitude: item.longitude,
        title: item.to_inline_title,
        input_message_content: Telegram::Bot::Types::InputVenueMessageContent.new(
            latitude: item.latitude,
            longitude: item.longitude,
            title: item.name,
            address: item.to_string
        ))
  end
end