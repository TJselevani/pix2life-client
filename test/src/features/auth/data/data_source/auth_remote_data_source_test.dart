// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:pix2life/core/dtos/create_user_dto.dart';
// import 'package:pix2life/core/error/exceptions.dart';
// import 'package:pix2life/core/utils/typeDef.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_remote_data_source.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_manager.dart';
// import 'package:pix2life/src/auth/data/models/user.model.dart';
// import 'package:pix2life/src/auth/data/data_source/auth_user_service.dart';

// class MockUserService extends Mock implements UserService {}

// class MockAuthManager extends Mock implements AuthManager {}

// @GenerateMocks([UserService, AuthManager])
// void main() {
//   late AuthRemoteDataSourceImpl dataSource;
//   late MockUserService mockUserService;
//   late MockAuthManager mockAuthManager;

//   setUp(() {
//     mockUserService = MockUserService();
//     mockAuthManager = MockAuthManager();
//     dataSource = AuthRemoteDataSourceImpl(mockUserService, mockAuthManager);
//   });

//   group('userSignUp', () {
//     const String tUsername = 'testUser';
//     const String tEmail = 'test@example.com';
//     const String tAddress = '123 Street';
//     const String tPhoneNumber = '1234567890';
//     const String tPostCode = '12345';
//     const String tToken = 'fake_token';
//     const String tMessage = 'User created successfully';

//     final DataMap tUserJson = {
//       'username': tUsername,
//       'email': tEmail,
//       'address': tAddress,
//       'phoneNumber': tPhoneNumber,
//       'postCode': tPostCode,
//     };

//     final CreateUserResponse tCreateUserResponse = CreateUserResponse(
//       token: tToken,
//       user: tUserJson,
//       message: tMessage,
//     );

//     final UserModel tUserModel = UserModel.fromJson(tUserJson);

//     test('should return UserModel when the sign up is successful', () async {
//       // Arrange
//       when(() {
//         mockUserService.createUser(any(named: 'userData'));
//       }).thenAnswer((_) async => tCreateUserResponse);
//       when(() {
//         mockAuthManager.storeToken(any);
//       }).thenAnswer((_) async => Future.value());

//       // Act
//       final result = await dataSource.userSignUp(
//         username: tUsername,
//         email: tEmail,
//         address: tAddress,
//         phoneNumber: tPhoneNumber,
//         postCode: tPostCode,
//       );

//       // Assert
//       verify(mockUserService.createUser(any));
//       verify(mockAuthManager.storeToken(tToken));
//       expect(result, tUserModel);
//     });

//     test('should throw ServerException when there is a server error', () async {
//       // Arrange
//       when(mockUserService.createUser(any)).thenThrow(ServerException());

//       // Act
//       final call = dataSource.userSignUp;

//       // Assert
//       expect(
//           () => call(
//                 username: tUsername,
//                 email: tEmail,
//                 address: tAddress,
//                 phoneNumber: tPhoneNumber,
//                 postCode: tPostCode,
//               ),
//           throwsA(isA<ServerException>()));
//     });

//     test('should throw ApplicationError when any other exception occurs',
//         () async {
//       // Arrange
//       when(mockUserService.createUser(any)).thenThrow(Exception());

//       // Act
//       final call = dataSource.userSignUp;

//       // Assert
//       expect(
//           () => call(
//                 username: tUsername,
//                 email: tEmail,
//                 address: tAddress,
//                 phoneNumber: tPhoneNumber,
//                 postCode: tPostCode,
//               ),
//           throwsA(isA<ApplicationError>()));
//     });
//   });
// }
