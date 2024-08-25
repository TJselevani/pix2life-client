class ResetPasswordResponse {
  final String message;
  final Map<String, dynamic>  user;

  ResetPasswordResponse({required this.user, required this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(message: json['message'], user: json['user']);
  }
}
