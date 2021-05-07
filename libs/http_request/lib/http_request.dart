
import 'dart:async';

import 'package:flutter/services.dart';

class HttpRequest {
  static const MethodChannel _channel =
      const MethodChannel('http_request');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get(final String url, {final Map<String, String> headers, final Map<String, String> params}) async {
    final result = await _channel.invokeMethod('sendRequest', {
      "url": url,
      "headers": headers,
      "params": params,
    });
    return result;
  }
}
