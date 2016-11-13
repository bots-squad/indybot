module appsimple

import bots
import adapter.slack

function main = |args| {
  println("🤖 Indy[slack] is started ✨✨✨")
  let indy = indyBot()

  indy: connect(System.getenv("SLACK_INDY_TOKEN"))

  println("🤖 Indy[slack] is listening 👂")

  indy: onActive({
    println("🤖 Indy[slack][active] id: " + indy: id())
    indy: sendMessage("Hello :earth_africa:", "testbob")
  })

  indy: listen(|message| {
    indy: sendMessage(":kissing_smiling_eyes: yo <@"+message: user()+">, I'm Indy", "testbob")
    println("  channel name: " + indy: getChannelById(message: channel()): name())
    println("  sender: " + message: user())
    println("  team: " + message: team())
    println("  text: " + message: text())
  })
}
