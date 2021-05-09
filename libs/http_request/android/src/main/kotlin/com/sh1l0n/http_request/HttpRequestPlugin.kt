//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

package com.sh1l0n.http_request

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.lang.Exception
import java.net.HttpURLConnection
import java.net.URL


class HttpRequestPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private val sendGetRequestName = "get";
  private val urlArgumentName = "url"
  private val headersArgumentName = "headers"
  private val paramsArgumentName = "params"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "http_request")
    channel.setMethodCallHandler(this)
  }
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val url = call.argument<String?>(urlArgumentName)
    val headers = call.argument<Map<String, String>?>(headersArgumentName)
    val params = call.argument<Map<String, String>?>(paramsArgumentName)

    when (call.method) {
          sendGetRequestName -> {
              GlobalScope.launch(Dispatchers.IO) {
                val message: String = NetworkRequest().get(url, headers, params)
                GlobalScope.launch(Dispatchers.Main) {
                  result.success(message)
                }
              }
          }
          else -> {
              result.notImplemented()
          }
      }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
