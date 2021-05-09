//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'dart:async';

import 'package:flutter/services.dart';

class HttpRequest {
  static const MethodChannel _channel =
      const MethodChannel('http_request');

  static Future<String> get(final String url, {final Map<String, String>? headers, final Map<String, String>? params}) async {
    final result = await _channel.invokeMethod('get', {
      "url": url,
      "headers": headers,
      "params": params,
    });
    return result;
  }
}
