module approcketchat

import bots
import adapter.rocket.chat

----
sudo pico ~/.bash_profile
export ROCKETCHAT_INDY_USER=indy
export ROCKETCHAT_INDY_PASSWORD=password_of_indy_in_rocket_chat
export ROCKETCHAT_INDY_URL=http://localhost:8083
----
function main = |args| {
  let indy = indyBot()
  println("🤖 Indy[rocket.chat] is started ✨✨✨")
  let userName = System.getenv("ROCKETCHAT_INDY_USER")
  let userPassword = System.getenv("ROCKETCHAT_INDY_PASSWORD")
  let urlConnection = System.getenv("ROCKETCHAT_INDY_URL")

  let connection = indy: delay(2000_L): connect(urlConnection, userName, userPassword)

  let connectionError = {
    println("😡 Indy can't connect to Rocket.Chat")
  }

  let connectionSuccess = {
    println("😍 Indy is connected")
    println("🏠 Rooms:")
    indy: getPublicRooms(): get(): rooms(): each(|room| -> println(JSON.stringify(room)))

    indy: sendMessage("Hello :earth_africa:", "general")

    println("🤖 Indy[rocket.chat] is listening 👂")

    indy: listen("general", |message| {
      println(message: msg())
      indy: sendMessage(
        "Hello :heart: @" + message: u(): username() + " How are you? :stuck_out_tongue_winking_eye:",
        "general"
      )
    })
    
    indy: listen("ops", |message| {
      println(message: msg())
      indy: sendMessage(
        "Hello :heart: @" + message: u(): username() + " :wink:",
        "ops"
      )
    })
  }

  let connectionUnexpected = {
    println("🤔 It's embarrassing")
  }

  match {
    when connection: isError() then connectionError()
    when connection: isValue() then connectionSuccess()
    otherwise connectionUnexpected()
  }

  # message
  #   _id
  #   _updatedAt
  #   mentions []
  #   _id
  #   username
  #   msg
  #   u {} from
  #     _id
  #     username



}
