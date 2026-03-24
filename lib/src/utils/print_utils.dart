import 'package:flutter/services.dart';

class PrintUtils {
  PrintUtils._();

  static startPrint(String content) async {
    return await const MethodChannel('androidChannel').invokeMethod('wiseasyPrint', content);
  }
}
