import 'dart:convert';

import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.address,
    required super.phoneNumber,
    required super.postCode,
    required super.avatarUrl,
    required super.lastLogin,
    required super.subscriptionPlan,
  });

  //For Running Test
  UserModel.empty()
      : this(
          id: '1',
          username: '_empty.username',
          email: '_empty.email',
          address: '_empty.address',
          phoneNumber: '_empty.phoneNumber',
          postCode: '_empty.postCode',
          avatarUrl: '_empty.avatarUrl',
          lastLogin: '_empty.lastLogin',
          subscriptionPlan: '_empty.subscriptionPlan',
        );

  factory UserModel.fromJson(DataMap json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      postCode: json['postCode'],
      avatarUrl: json['avatarUrl'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      subscriptionPlan: json['subscriptionPlan'] ?? '',
    );
  }

  factory UserModel.fromJSON(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          username: map['username'] as String,
          email: map['email'] as String,
          address: map['address'] as String,
          phoneNumber: map['phoneNumber'] as String,
          postCode: map['postCode'] as String,
          avatarUrl: map['avatarUrl'] ?? '',
          lastLogin: map['lastLogin'] ?? '',
          subscriptionPlan: map['subscriptionPlan'] ?? '',
        );
        
  DataMap toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "address": address,
        "phoneNumber": phoneNumber,
        "postCode": postCode,
        "avatarUrl": avatarUrl,
        "lastLogin": lastLogin,
        "subscriptionPlan": subscriptionPlan,
      };

  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? address,
    String? phoneNumber,
    String? postCode,
    String? avatarUrl,
    String? lastLogin,
    String? subscriptionPlan,
  }) =>
      UserModel(
        id: this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        address: address ?? this.address,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        postCode: postCode ?? this.postCode,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        lastLogin: this.lastLogin,
        subscriptionPlan: this.subscriptionPlan,
      );
}
