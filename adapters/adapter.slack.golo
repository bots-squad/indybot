module adapter.slack

import http
import JSON
import gololang.Errors

import com.github.seratch.jslack.Slack # see https://github.com/seratch/jslack
import com.github.seratch.jslack.api.methods.response.channels.ChannelsListResponse
import com.github.seratch.jslack.api.methods.request.channels.ChannelsListRequest
import com.github.seratch.jslack.shortcut.model.ChannelName

local function getSlackInstance = {
  return  Slack.getInstance()
}


augmentation botSlackFeatures = {
  function yo = |this| -> println("🤖 Yo! I'm the Slack adapter")

  function connect = |this, token| {
    this: rtmClient(Slack(): rtm(token))
    let conn = this: rtmClient(): connect()
    this: token(token)
    return this
  }

  ----
      indy: listenAll(|message| {
        println("Message type: " + message: type())
        match {
          when message: type(): equals("presence_change") then {
            println("  Indy id: " + message: user())
            indy: id(message: user())
          }()
          when message: type(): equals("message") and message: text(): contains("<@"+indy: id()+">") then {
            println(JSON.stringify(message))
            indy: sendMessage(":kissing_smiling_eyes: yo, I'm Indy", "testbob")
            println("  channel: " + message: channel())

            println(indy: getChannelById(message: channel()): get(): name())

            println("  sender: " + message: user())
            println("  team: " + message: team())
            println("  text: " + message: text())
          }()
          otherwise "..."
        }
      })
  ----
  function listenAll = |this, handler| {
    return this: startJob(|this| { # this is a worker -> send false to stop it
      this: rtmClient(): addMessageHandler(|message| {
        handler(JSON.toDynamicObjectTreeFromString(message))
      })
    })
  }

  ----
      indy: listen(|message| {
        println("Indy id: " + indy: id())
        println(JSON.stringify(message))
        indy: sendMessage(":kissing_smiling_eyes: yo, I'm Indy", "testbob")
        println(indy: getChannelById(message: channel()): name())
      })
  ----
  function listen = |this, handler| {
    return this: startJob(|this| { # this is a worker -> send false to stop it
      this: rtmClient(): addMessageHandler(|message| {
        let dynoMessage = JSON.toDynamicObjectTreeFromString(message)
        if dynoMessage: type(): equals("message") and dynoMessage: text(): contains("<@"+this: id()+">") {
          handler(dynoMessage)
        }
      })
    })
  }

  function onActive = |this, handler| {
    this: rtmClient(): addMessageHandler(|message| {
      let dynoMessage = JSON.toDynamicObjectTreeFromString(message)
      if dynoMessage: type(): equals("presence_change") and dynoMessage: presence(): equals("active") {
        this: id(dynoMessage: user())
        #println("🤖 id: " + this: id()) # if no print no work 😜
        handler()
      }
    })
  }

  function getChannels = |this| {
    let slack = getSlackInstance!()
    # ChannelsListResponse
    let channelsResponse  = slack: methods(): channelsList(
      ChannelsListRequest.builder(): token(this: token()): build()
    )
    if channelsResponse: ok() {
      let addChannel = |acc, nextChannel| -> acc: append(
        DynamicObject()
          : id(nextChannel: id())
          : name(nextChannel: name())
          : members(nextChannel: members())
      )
      let channels = channelsResponse: channels(): reduce(list[], addChannel)

      return channels
    } else {
      return channelsResponse: error() orIfNull channelsResponse: warning()
    }
  }

  function getChannelByName = |this, name| {
    return this: getChannels(): find(|channel| -> channel: name(): equals(name))
  }

  function getChannelById = |this, id| {
    return this: getChannels(): find(|channel| -> channel: id(): equals(id))
  }

  function sendMessage = |this, message, roomName| { # to refactor

    let slack = getSlackInstance!()
    let channelName = ChannelName.of(roomName)

    let resp = slack: methods(): chatPostMessage(
      com.github.seratch.jslack.api.methods.request.chat.ChatPostMessageRequest.builder()
        : token(this: token())
        : asUser(true)
        : channel(channelName: getValue())
        : text(message)
        : attachments(list[])
        : build()
    )
    return resp
  }
}

augment bots.types.indyBot with botSlackFeatures
