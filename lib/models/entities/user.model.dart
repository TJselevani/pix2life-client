class User {
  final String id;
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;
  final String avatarUrl;
  final String lastLogin;
  final String subscriptionPlan;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      postCode: json['postCode'],
      avatarUrl: json['avatarUrl'],
      lastLogin: json['lastLogin'] ?? '',
      subscriptionPlan: json['subscriptionPlan'] ?? '',
    );
  }
}
