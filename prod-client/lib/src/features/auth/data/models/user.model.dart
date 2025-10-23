import 'dart:convert';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
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

  // For Running Tests
  const UserModel.empty()
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

  // Factory constructor to create a UserModel from a JSON Map
  factory UserModel.fromJson(DataMap json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      postCode: json['postCode'] as String,
      avatarUrl: json['avatarUrl'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      subscriptionPlan: json['subscriptionPlan'] ?? '',
    );
  }

  // Factory constructor to create a UserModel from a JSON string
  factory UserModel.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap =
        jsonDecode(source) as Map<String, dynamic>;
    return UserModel.fromJson(jsonMap);
  }

  // Factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(DataMap map) {
    return UserModel(
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
  }

  // Converts the UserModel to a Map
  DataMap toMap() {
    return {
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
  }

  // Converts the UserModel to a JSON string
  String toJson() => jsonEncode(toMap());

  // Creates a copy of the UserModel with updated fields
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
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      postCode: postCode ?? this.postCode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastLogin: lastLogin ?? this.lastLogin,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }
}
