class UserSignInResponse {
  final Map<String, dynamic> user;
  final String token;
  final String message;

  UserSignInResponse(
      {required this.user, required this.token, required this.message});

  factory UserSignInResponse.fromJson(Map<String, dynamic> json) {
    return UserSignInResponse(
      user: json['user'],
      token: json['token'],
      message: json['message'],
    );
  }
}
