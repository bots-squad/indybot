# IndyBot

> WIP :construction:

> IndyBot is a bot powered by invokedynamic

## IndyBot for Slack

- create a bot and get a token (https://api.slack.com/bot-users) for your bot
- invite the bot in a channel
- set an environment variable for the token, eg `export SLACK_INDY_TOKEN=bot_token_from_slack`

### application script

- script is in `/applications`
- its name is `app.slack.golo` *remark: you can rename it or create a new one, so don't forget to update `indybot.slack.sh`*

:warning: :wave: you can run it like that: `SLACK_INDY_TOKEN=your_token golo golo --classpath jars/*.jar  --files core/*.golo adapters/adapter.slack.golo applications/app.slack.golo 
`

#### minimal application script

```golo
module appslack

import bots
import adapter.slack  # the needed adapter

function main = |args| {
  let indy = indyBot()
  indy: connect(System.getenv("SLACK_INDY_TOKEN")) # get the token

  # it allows to set the id of IndyBot
  indy: onActive({
    indy: sendMessage("Hello :earth_africa:", "testbob")
  })

  # IndyBot is listening
  # IndyBot is triggered if somebody sends a message with a notification for him
  indy: listen(|message| {

    let txt = message: text()

    # IndyBot answers to the sender
    indy: sendMessage(
      ":kissing_smiling_eyes: yo <@"+message: user()+">, I'm Indy",
      "testbob"
    )
  })
}
```

#### run IndyBot

- type: `./indybot.slack.sh`
- or `golo golo --classpath jars/*.jar  --files core/*.golo adapters/adapter.slack.golo applications/app.slack.golo`

> You have to set the adapter and the application script


## IndyBot for Rocket.Chat

- create a bot in Rocket.Chat
- invite the bot in a room
- set environment variables:
```
export ROCKETCHAT_INDY_USER=indy
export ROCKETCHAT_INDY_PASSWORD=password_of_indy_in_rocket_chat
export ROCKETCHAT_INDY_URL=http://localhost:8083
```

### application script

- script is in `/applications`
- its name is `app.rocket.chat.golo` *remark: you can rename it or create a new one, so don't forget to update `indybot.rocket.chat.sh`*

#### minimal application script

```golo
module approcketchat

import bots
import adapter.rocket.chat  # the needed adapter

function main = |args| {
  let indy = indyBot()
  # get credentials
  let userName = System.getenv("ROCKETCHAT_INDY_USER")
  let userPassword = System.getenv("ROCKETCHAT_INDY_PASSWORD")
  let urlConnection = System.getenv("ROCKETCHAT_INDY_URL")

  let connection = indy: delay(2000_L): connect(urlConnection, userName, userPassword)

  let connectionSuccess = {
    indy: sendMessage("Hello :earth_africa:", "general")

    # IndyBot is listenin on "general" room
    # IndyBot is triggered if somebody sends a message with a notification for him
    indy: listen("general", |message| {
      println(message: msg())

      # IndyBot answers to the sender
      indy: sendMessage(
        "Hello :heart: @" + message: u(): username() + " How are you? :stuck_out_tongue_winking_eye:",
        "general"
      )
    })
  }

  match {
    when connection: isError() then println("😡 Indy can't connect to Rocket.Chat")
    when connection: isValue() then connectionSuccess()
    otherwise println("🤔 It's embarrassing")
  }
}
```

#### run IndyBot

- type: `./indybot.rocket.chat.sh`
- or `golo golo --classpath jars/*.jar  --files core/*.golo adapters/adapter.rocket.chat.golo applications/app.rocket.chat.golo`

> You have to set the adapter and the application script

## Create an adapter for IndyBot

> WIP :construction:
