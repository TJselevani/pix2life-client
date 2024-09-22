import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/typeDef.dart';

class GetImageResponse {
  final FormData file;

  GetImageResponse({required this.file});

  factory GetImageResponse.fromJson(DataMap json) {
    return GetImageResponse(
      file: json['message'],
    );
  }
}
