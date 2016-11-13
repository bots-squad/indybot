module http

import gololang.Errors
import JSON


#System.setProperty("log_http", "false")
local function logging = {
  return trying(-> System.getProperty("log_http"))
    : either(
      |res| -> res?: equals("true") orIfNull false,
      |err| -> false
    )
}

local function logging = |what| {
  if logging!() is true { println(what) }
}

----
# isOk
Test if response is OK
----
function isOk = |code| -> [
  java.net.HttpURLConnection.HTTP_OK(),
  java.net.HttpURLConnection.HTTP_CREATED(),
  java.net.HttpURLConnection.HTTP_ACCEPTED()
]: exists(|value| -> value: equals(code))

struct response = {
  code,
  message,
  data
}

struct header = {
  property,
  value
}

@result
function request = |method, uri, data, headers| {
  let obj = java.net.URL(uri) # URL obj
  let connection = obj: openConnection() # HttpURLConnection
  connection: setRequestMethod(method)

  headers: each(|item| {
    connection: setRequestProperty(item: property(), item: value())
  })

  if data isnt null and ("POST": equals(method) or "PUT": equals(method)) {
    connection: setDoOutput(true)
    let dataOutputStream = java.io.DataOutputStream(connection: getOutputStream())
    dataOutputStream: writeBytes(data)
    #dataOutputStream: writeBytes(JSON.stringify(data))
    dataOutputStream: flush()
    dataOutputStream: close()
  }

  let responseCode = connection: getResponseCode()
  let responseMessage = connection: getResponseMessage()

  logging("LOG> Http.request > responseCode: " + responseCode)
  logging("LOG> Http.request > responseMessage: " + responseMessage)


  if isOk(responseCode) {
    let responseText = java.util.Scanner(
      connection: getInputStream(),
      "UTF-8"
    ): useDelimiter("\\A"): next() # String responseText
    logging("LOG> Http.request > responseText: " + responseText)
    return response(responseCode, responseMessage, responseText)
    #return response(responseCode, responseMessage, JSON.parse(responseText))
  } else {
    return response(responseCode, responseMessage, null)
  }
}

struct httpClient = {
  baseUri, headers
}

augment httpClient {

  function getUri = |this, path| {
    return this: baseUri() + path
  }
  function getData = |this, path| {
    logging("LOG> getData: " + this: getUri(path))
    let resp = request("GET", this: getUri(path), null, this: headers())
    logging("LOG> getData > response: " + resp)
    return resp
  }
  function postData = |this, path, data| {
    logging("LOG> postData: " + this: getUri(path))
    let resp =  request("POST", this: getUri(path), JSON.stringify(data), this: headers())
    logging("LOG> postData > response: " + resp)
    return resp
  }

  function putData = |this, path, data| {
    logging("LOG> putData: " + this: getUri(path))
    let resp =  request("PUT", this: getUri(path), JSON.stringify(data), this: headers())
    logging("LOG> putData > response: " + resp)
    return resp
  }
  # TODO: deleteData

}
