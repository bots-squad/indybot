module bots

struct indyBot = {
  id,
  name,
  httpClient,
  rtmClient,
  token,
  delay             # pooling
}
