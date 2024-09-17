import 'package:pix2life/features/auth/domain/entities/user.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
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
}
