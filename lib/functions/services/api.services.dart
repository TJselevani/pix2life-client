import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'dart:convert';
import 'package:pix2life/functions/errors/errors.dart';
import 'package:pix2life/functions/errors/error_handler.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  final log = logger(ApiService);

  Future<dynamic> fetchData(String uri) async {
    final String? token = await storage.read(key: 'auth_token');
    try {
      final response = await _dio.get(
        uri,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.data);
        return response.data;
      } else {
        throw BadRequest(
          message:
              response.data['message'] ?? 'Failed to fetch data from endpoint',
          status: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      log.i('$e');
      ErrorHandler.handleError(e);
    }
  }

  Future<dynamic> sendData(dynamic data, String uri) async {
    final String? token = await storage.read(key: 'auth_token');
    try {
      final response = await _dio.post(
        uri,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log.i(response.data);
        return response.data;
      } else {
        throw BadRequest(
          message: response.data['message'] ?? 'Failed to send data',
          status: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      log.i('$e');
      ErrorHandler.handleError(e);
    }
  }

  Future<dynamic> uploadFile(FormData formData, String uri) async {
    final String? token = await storage.read(key: 'auth_token');
    try {
      final response = await _dio.post(
        uri,
        data: formData,
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        log.i(response.data);
        return response.data;
      } else {
        throw BadRequest(
          message: response.data['message'] ?? 'Failed to Upload File',
          status: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      log.i('$e');
      ErrorHandler.handleError(e);
    }
  }

  Future<dynamic> updateData(dynamic data, String uri) async {
    final String? token = await storage.read(key: 'auth_token');
    try {
      final response = await _dio.put(
        uri,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.data);
        return response.data;
      } else {
        throw BadRequest(
          message:
              response.data['message'] ?? 'Failed to fetch data from endpoint',
          status: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      log.i('$e');
      ErrorHandler.handleError(e);
    }
  }

  Future<dynamic> deleteData(String uri) async {
    final String? token = await storage.read(key: 'auth_token');
    try {
      final response = await _dio.delete(
        uri,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        log.i('Successfully deleted data');
        return response.data;
      } else {
        throw BadRequest(
          message:
              response.data['message'] ?? 'Failed to delete data from endpoint',
          status: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      log.i('$e');
      ErrorHandler.handleError(e);
    }
  }
}
