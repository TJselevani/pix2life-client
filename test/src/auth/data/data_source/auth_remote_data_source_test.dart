// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:pix2life/core/error/exceptions.dart';
// import 'package:pix2life/core/secrets/app_secrets.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_manager.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_remote_data_source.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_user_service.dart';
// import 'package:pix2life/src/auth/data/models/user.model.dart';

// class MockClient extends Mock implements UserService{}

// void main() {
//   late UserService client;
//   late AuthManager authManager = AuthManager();
//   late AuthRemoteDataSource remoteDataSource;

//   setUp(() {
//     client = MockClient();
//     remoteDataSource =
//         AuthRemoteDataSourceImpl(client, authManager);
//     registerFallbackValue(Uri());
//   });

//   final UserModel user = UserModel.empty();

//   group('SignInUser', () {
//     test('complete successfully on status 200 or 201', () async {
      
//       //arrange
//       when(() => client.sendData(any(named: 'data'), any()))
//           .thenAnswer(
//               (_) async => Future.value(user));

//       //act
//       final methodCall = await remoteDataSource.userSignIn;

//       //assert
//       expect(methodCall(email: 'email', password: 'password'),
//           equals(Future.value(user)));

//       verify(
//         () => client.sendData(any(named: 'data'), any())
//       ).called(1);

//       verifyNoMoreInteractions(client);
//     });

//     test('should throw [ServerException] when status code is not 200 or 201',
//         () async {
//       //arrange
//       when(() => client.
//           ).thenAnswer((_) async => http.Response('invalid user data', 400));

//       //act
//       final methodCall = await remoteDataSource.userSignIn;

//       //assert
//       expect(
//         () => methodCall(email: 'email', password: 'password'),
//         throwsA(
//            ServerException(
//             message: 'invalid user data',
//             statusCode: 400,
//           ),
//         ),
//       );

//       verify(
//         () => client.post(
//           Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
//           body: jsonEncode({'email': 'email', 'password': 'password'}),
//         ),
//       ).called(1);

//       verifyNoMoreInteractions(client);
//     });
//   });
// }
