package com.sh1l0n.http_request

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.MalformedURLException
import java.net.URL

class NetworkRequest {
  companion object fun get(url: String?, headers: Map<String, String>?, params: Map<String, String>?): String {
    val encodedUrl = url + if(params!=null) "?" + urlEncodeParams(params) else ""
    return request(encodedUrl, "GET", headers, mapOf())
  }

  private fun urlEncodeParams(params: Map<String, String>): String {
    var encoded = ""
    val keys = params.keys.toList()
    for (index in keys.indices) {
      encoded += keys[index] + "=" + params[keys[index]] +
          if(index < keys.size - 1) "&" else ""
    }
    return encoded
  }

  private fun request(url: String?, method: String, headers: Map<String, String>?, params: Map<String, String>?): String {
    if (url == null || url.isEmpty()) {
      return "{\"error\": \"$-1\", \"message\":\"Should specify an url\"}"
    }

    lateinit var request: HttpURLConnection
    try {
      val address = URL(url)
      request = address.openConnection() as HttpURLConnection
      request.useCaches = false
      request.doInput = true
      request.doOutput = true
      if (headers != null) {
        for ((k, v) in headers) {
          request.setRequestProperty(k, v)
        }
      }
      //TODO: Perform params on body request
      request.requestMethod = method
      val br = BufferedReader(InputStreamReader(request.inputStream))
      val sb = StringBuilder()
      var line: String?
      while (br.readLine().also { line = it } != null) {
        sb.append(line?.trimIndent() ?: "")
      }
      br.close()
      return sb.toString()
    } catch (e: MalformedURLException) {
      return "{\"error\": \"$-2\", \"message\":\"$e\"}"
    } catch (e: IOException) {
      val responseCode = request.responseCode
      return "{\"error\": \"$responseCode\", \"message\":\"$e\"}"
    }
  }
}
