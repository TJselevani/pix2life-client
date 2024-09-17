import 'package:dio/dio.dart';

class GetImageResponse {
  final FormData file;

  GetImageResponse({required this.file});

  factory GetImageResponse.fromJson(Map<String, dynamic> json) {
    return GetImageResponse(
      file: json['message'],
    );
  }
}
