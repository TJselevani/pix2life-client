import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;
  final String avatarUrl;
  final String lastLogin;
  final String subscriptionPlan;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.postCode,
    required this.avatarUrl,
    required this.lastLogin,
    required this.subscriptionPlan,
  });

  const User.empty()
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

  @override
  List<Object?> get props => [id, username, email];
}
