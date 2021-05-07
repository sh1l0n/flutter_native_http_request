package com.sh1l0n.http_request

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
//import okhttp3.*
//import java.io.IOException
//import java.net.HttpURLConnection
//import java.net.URL

/** HttpRequestPlugin */
class HttpRequestPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel

  private val getPlatformVersionName = "getPlatformVersion";
  private val sendRequestName = "sendRequest";

//  private lateinit var httpClient: OkHttpClient

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "http_request")
    channel.setMethodCallHandler(this)
//    httpClient = OkHttpClient()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        getPlatformVersionName -> {
          result.success(getPlatformVersion())
        }
        sendRequestName -> {
          val url = call.argument<String>("url")
          val headers = call.argument<Map<String, String>>("headers")
          val params = call.argument<Map<String, String>>("params")
          sendRequest(url, headers, params)
          result.success("Send request ok")
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getPlatformVersion(): String {
    return "Android ${android.os.Build.VERSION.RELEASE}"
  }

  private fun sendRequest(url: String?, headers: Map<String, String>?, params: Map<String, String>?) {

    println("url $url")
    println("headers: $headers")
    println("params: $params")

//    if (url==null) {
//      println("Should specify an url")
//      return
//    }
//
//    val request = Request.Builder().url(url)
//    if (headers!=null) {
//      for ((k,v) in headers) {
//        request.addHeader(k, v)
//      }
//    }

//    httpClient.newCall(request.build()).enqueue(object : Callback {
//      override fun onFailure(call: Call, e: IOException) {
//        e.printStackTrace()
//      }
//
//      override fun onResponse(call: Call, response: Response) {
//        response.use {
//          if (!response.isSuccessful) throw IOException("Unexpected code $response")
//
//          for ((name, value) in response.headers) {
//            println("$name: $value")
//          }
//
//          println(response.body!!.string())
//        }
//      }
//    })
  }
}
