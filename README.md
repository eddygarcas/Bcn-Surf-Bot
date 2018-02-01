# BcnSurfBot

Shows surf forecasts feeding from Magicseaweed api.

# Ruby gems

The file *bcn_surf_bot.rb* requires Telegram Bot

    require 'telegram/bot'

#### Versions

    gem 'telegram-bot-ruby', '~> 0.7.2'
    
### Procfile

In order to run this application in Heroku must include a Procfile adding the following config line

    Web: bundle exec ruby bcn_surf_bot.rb

# Testing

Before starting this app in Heroku it's imperative adding a couple of environment variables. First one would be the Telegram Token string generated at creating the bot as well as other API token you need.

    TELEGRAM_BOT_TOKEN 

