import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pix2life/core/error/error_handler.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';

class MockDio extends Mock implements Dio {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockErrorHandler extends Mock implements ErrorHandler {}

void main() {
  late ApiService apiService;
  late MockDio mockDio;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockFlutterSecureStorage();
    apiService = ApiService(mockDio, mockStorage);
  });

  group('ApiService', () {
    const String testUri = '';
    const String token = 'test_token';

    // Mock secure storage to return a token
    setUp(() {
      when(() => mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => token);
    });

    group('fetchData (GET request)', () {
      test('should return data on 200 status', () async {
        //Arrange
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 200,
          data: {'result': 'success'},
        );

        when(() => mockDio.get(any(), options: any(named: 'options')))
            .thenAnswer((_) async => response);

        //Act
        final result = await apiService.fetchData(testUri);

        //Assert
        expect(result, equals(response.data));
        verify(() => mockStorage.read(key: 'auth_token')).called(1);
        verify(() => mockDio.get(any(), options: any(named: 'options')))
            .called(1);
        verifyNoMoreInteractions(mockDio);
        verifyNoMoreInteractions(mockStorage);
      });

      test('should throw [ServerException] on 400 status', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 400,
          data: {'message': 'Bad Request'},
        );

        when(() => mockDio.get(any(), options: any(named: 'options')))
            .thenThrow(DioException(
          requestOptions: response.requestOptions,
          response: response,
        ));

        // Act and Assert
        expect(() async => await apiService.fetchData(testUri),
            throwsA(isA<ServerException>()));
      });
    });

    group('sendData (POST request)', () {
      test('should return data on 200/201 status', () async {
        //Arrange
        final data = {'key': 'value'};
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 201,
          data: {'result': 'success'},
        );

        when(() => mockDio.post(any(),
            data: any(named: 'data'),
            options: any(named: 'options'))).thenAnswer((_) async => response);

        //Act
        final result = await apiService.sendData(data, testUri);

        //Assert
        expect(result, equals(response.data));
      });

      test('should throw [DioException] on non-200 status', () async {
        //Arrange
        final data = {'key': 'value'};
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 400,
          data: {'message': 'Bad Request'},
        );

        when(() => mockDio.post(any(),
            options: any(named: 'options'),
            data: any(named: 'data'))).thenThrow(DioException(
          requestOptions: response.requestOptions,
          response: response,
        ));

        // Act and Assert
        expect(() async => await apiService.sendData(data, testUri),
            throwsA(isA<ServerException>()));
      });
    });

    group('uploadFile (POST file upload)', () {
      test('should return data on 200/201 status', () async {
        //Arrange
        final formData = FormData.fromMap({'file': 'file_data'});
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 200,
          data: {'result': 'success'},
        );

        when(() => mockDio.post(any(),
            data: any(named: 'data'),
            options: any(named: 'options'))).thenAnswer((_) async => response);

        //Act
        final result = await apiService.uploadFile(formData, testUri);

        //Assert
        expect(result, equals(response.data));
      });

      test('should throw DioException on non-200 status', () async {
        //Arrange
        final formData = FormData.fromMap({'file': 'file_data'});
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 400,
          data: {'message': 'Bad Request'},
        );

        when(() => mockDio.post(any(),
            options: any(named: 'options'),
            data: any(named: 'data'))).thenThrow(DioException(
          requestOptions: response.requestOptions,
          response: response,
        ));

        // Act and Assert
        expect(() async => await apiService.uploadFile(formData, testUri),
            throwsA(isA<ServerException>()));
      });
    });

    group('updateData (PUT request)', () {
      test('should return data on 200/201 status', () async {
        // Arrange
        final data = {'key': 'value'};
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 200,
          data: {'result': 'success'},
        );

        when(() => mockDio.put(any(),
            data: any(named: 'data'),
            options: any(named: 'options'))).thenAnswer((_) async => response);

        //Act
        final result = await apiService.updateData(data, testUri);

        //Assert
        expect(result, equals(response.data));
      });

      test('should throw DioException on non-200 status', () async {
        //Arrange
        final data = {'key': 'value'};
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 400,
          data: {'message': 'Bad Request'},
        );

        when(() => mockDio.put(any(),
            options: any(named: 'options'),
            data: any(named: 'data'))).thenThrow(DioException(
          requestOptions: response.requestOptions,
          response: response,
        ));

        //Act and Assert
        expect(() async => await apiService.updateData(data, testUri),
            throwsA(isA<ServerException>()));
      });
    });

    group('deleteData (DELETE request)', () {
      test('should return success on 200 status', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 200, // No content response
        );

        when(() => mockDio.delete(any(), options: any(named: 'options')))
            .thenAnswer((_) async => response);

        // Act
        final result = await apiService.deleteData(testUri);

        // Assert
        expect(result, isNull); // Expecting no content
        verify(() => mockDio.delete(any(), options: any(named: 'options')))
            .called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should throw DioException on non-200 status', () async {
        //Arrange
        final response = Response(
          requestOptions: RequestOptions(path: testUri),
          statusCode: 400,
          data: {'message': 'Bad Request'},
        );

        when(() => mockDio.delete(any(), options: any(named: 'options')))
            .thenThrow(DioException(
          requestOptions: response.requestOptions,
          response: response,
        ));

        //Act and Assert
        expect(() async => await apiService.deleteData(testUri),
            throwsA(isA<ServerException>()));
      });
    });
  });
}
