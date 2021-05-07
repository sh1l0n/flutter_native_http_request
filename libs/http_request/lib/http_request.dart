
import 'dart:async';

import 'package:flutter/services.dart';

class HttpRequest {
  static const MethodChannel _channel =
      const MethodChannel('http_request');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
