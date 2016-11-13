module bots

import java.lang.Thread
import gololang.concurrent.workers.WorkerEnvironment

let workerEnvironment = WorkerEnvironment.builder(): withFixedThreadPool()
local function WorkerEnv = -> workerEnvironment

struct indyBot = {
  id,
  name,
  httpClient,
  rtmClient,
  token,
  delay             # pooling
}

augment indyBot {
  function startJob = |this, delay, somethingToDo| {
    let env = WorkerEnv()
    let worker = env: spawn(|message| {
      while (message) {
        somethingToDo(this)
        Thread.sleep(delay)
      }
    }): send(true)
    return worker
  }

  function startJob = |this, somethingToDo| {
    let env = WorkerEnv()
    let worker = env: spawn(|message| {
      somethingToDo(this)
      while (message) {
        # foo
        Thread.sleep(5000_L)
      }
    }): send(true)
    return worker
  }
}
