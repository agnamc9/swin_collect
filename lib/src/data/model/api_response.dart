import '../data.dart';

class ApiResponse<T> {
  bool? success;
  List<T>? items;
  String? message;

  ApiResponse({this.message, this.success = true, this.items});
}
