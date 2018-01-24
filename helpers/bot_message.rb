START_BOT_MESSAGE = "Thanks for using BcnSurf forecast Bot.\nThis bot will provide surf forecast from spots nearby Barcelona."

BOT_ERROR_MESSAGE = "Oops! Something went wrong, please press /start button again."

BOT_HELP_MESSAGE = "Use inline buttons below here, or type the inline command @bcnsurfbot in any chat to find out the forecast.\n"

BOT_ACTION_MESSAGE = "Surf spots near by Barcelona:"

BOT_MSW_LINK = "More at https://magicseaweed.com/"

class BotMessage


  def self.send_bot_message(bot, chatId, markup, text = nil)
    if text.nil?
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{START_BOT_MESSAGE}},
                           reply_markup: markup)
    else
      bot.api.send_message(chat_id: chatId, text: %Q{#{BOT_MSW_LINK}})
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
        results: inline_result(item),
        cache_time: 10,
        is_personal: true
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
    Telegram::Bot::Types::InlineQueryResultVenue.new(
        id: count.to_s,
        latitude: item.latitude,
        longitude: item.longitude,
        title: item.name,
        address: item.to_s,
        thumb_url: item.charts[:swell.to_s],
        thumb_width: 150,
        thumb_height: 91,
        input_message_content: venue_message(item))
  end

  private

  def self.venue_message (item)
    Telegram::Bot::Types::InputVenueMessageContent.new(
        latitude: item.latitude,
        longitude: item.longitude,
        title: item.name,
        address: item.to_s
    )
  end

  def self.text_message (item)
    Telegram::Bot::Types::InputTextMessageContent.new(
        message_text: item.to_s,
        parse_mode: 'Markdown',
        disable_web_page_preview: true
    )
  end
end