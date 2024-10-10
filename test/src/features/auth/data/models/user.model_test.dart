import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';

import '../../../../../fixtures/fixtures_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    //assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the right data', () {
      //act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the right data', () {
      //act
      final result = UserModel.fromJsonString(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] of [UserModel] with the right data', () {
      //act
      final result = tModel.toMap();

      //assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [JSON] string of [UserModel] with the right data',
        () {
      //act
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "username": "_empty.username",
        "email": "_empty.email",
        "address": "_empty.address",
        "phoneNumber": "_empty.phoneNumber",
        "postCode": "_empty.postCode",
        "avatarUrl": "_empty.avatarUrl",
        "lastLogin": "_empty.lastLogin",
        "subscriptionPlan": "_empty.subscriptionPlan"
      });

      //assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with updated data', () {
      //act
      final result = tModel.copyWith(username: 'Paul');

      //assert
      expect(result.username, equals('Paul'));
    });
  });
}
