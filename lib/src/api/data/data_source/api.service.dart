import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pix2life/core/error/error_handler.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';

class ApiService {
  late final FlutterSecureStorage _storage;
  late final Dio _dio;
  ApiService(this._dio, this._storage);

  final logger = createLogger(ApiService);

  // GET Request
  Future<dynamic> fetchData(String uri) async {
    final String? token = await _storage.read(key: 'auth_token');
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
      logger.i(response.statusCode);
      logger.i(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException: $e');
      ErrorHandler.handleError(e);
    } catch (e) {
      logger.e('ApplicationError: $e');
      throw ApplicationError(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 505,
      );
    }
  }

  //POST Request
  Future<dynamic> sendData(dynamic data, String uri) async {
    final String? token = await _storage.read(key: 'auth_token');
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
      logger.i(response.statusCode);
      logger.i(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException: $e');
      ErrorHandler.handleError(e);
    } catch (e) {
      logger.e('ApplicationError: $e');
      throw ApplicationError(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 505,
      );
    }
  }

  //POST Request
  Future<dynamic> uploadFile(FormData formData, String uri) async {
    final String? token = await _storage.read(key: 'auth_token');
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
      logger.i(response.statusCode);
      logger.i(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException: $e');
      ErrorHandler.handleError(e);
    } catch (e) {
      logger.e('ApplicationError: $e');
      throw ApplicationError(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 505,
      );
    }
  }

  // PUT Request
  Future<dynamic> updateData(dynamic data, String uri) async {
    final String? token = await _storage.read(key: 'auth_token');
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
      logger.i(response.statusCode);
      logger.i(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException: $e');
      ErrorHandler.handleError(e);
    } catch (e) {
      logger.e('ApplicationError: $e');
      throw ApplicationError(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 505,
      );
    }
  }

  //DELETE request
  Future<dynamic> deleteData(String uri) async {
    final String? token = await _storage.read(key: 'auth_token');
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
      logger.i(response.statusCode);
      logger.i(response.data);
      return response.data;
    } on DioException catch (e) {
      logger.e('DioException: $e');
      ErrorHandler.handleError(e);
    } catch (e) {
      logger.e('ApplicationError: $e');
      throw ApplicationError(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 505,
      );
    }
  }
}
