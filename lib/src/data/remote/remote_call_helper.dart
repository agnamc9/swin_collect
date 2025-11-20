import 'dart:io';
import 'package:dio/dio.dart';

import '../data.dart';

Future<ApiResponse<T>> runBlock<T>(Future<ApiResponse<T>> Function() block) async {
  try {
    final response = await block();
    return response;
  } on DioException catch (e) {
    if (e.response != null && e.response!.data != null) {
      StringBuffer msg = StringBuffer();
      if (e.response!.data['message'] is String) {
        msg.write(e.response!.data['message'] as String);
      }

      if (e.response!.data['message'] is List) {
        msg.write((e.response!.data['message'] as List).join("\n"));
      }
      return Future.value(ApiResponse(success: false, message: msg.toString()));
    }
    final message = getMessageFromException(e);
    return Future.value(ApiResponse(success: false, message: message));
  }
}

String getMessageFromException(Object e) {
  if (e is DioException) {
    return RemoteMessages.errorMessage;
  }
  if (e is SocketException) {
    return RemoteMessages.noInternetMessage;
  }
  return RemoteMessages.errorMessage;
}
