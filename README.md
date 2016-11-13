# IndyBot

> WIP :construction:

## IndyBot for Slack

- create a bot and get a token (https://api.slack.com/bot-users) for your bot
- Invite the bot in a channel
- set an environment variable for the token, eg `export SLACK_INDY_TOKEN=bot_token_from_slack`

### application script

- script is in `/applications`
- its name is `app.slack.golo` *remark: you can rename it or create a new one, so don't forget to update `indybot.slack.sh`*

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


## IndyBot for Slack

> WIP :construction:


## Create an adapter for IndyBot

> WIP :construction:
