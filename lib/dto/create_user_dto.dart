class CreateUserResponse {
  final Map<String, dynamic> user;
  final String token;
  final String message;

  CreateUserResponse(
      {required this.token, required this.user, required this.message});

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      token: json['token'],
      user: json['user'],
      message: json['message'],
    );
  }
}
