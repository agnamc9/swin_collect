import 'dart:io';
import 'package:dio/dio.dart';

import '../data.dart';

Future<ApiResponse<T>> runBlock<T>(Future<ApiResponse<T>> Function() block) async {
  try {
    final response = await block();
    return response;
  } on DioException catch (e) {
    if (e.response != null && e.response!.data != null) {
      return Future.value(ApiResponse(success: false, message: ((e.response!.data['message'] ?? e.response!.data['error']) as String)) );
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
