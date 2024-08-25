class UserFromTokenResponse {
  final Map<String, dynamic> user;

  UserFromTokenResponse({required this.user});

  factory UserFromTokenResponse.fromJson(Map<String, dynamic> json) {
    return UserFromTokenResponse(
      user: json['user'],
    );
  }
}
