class VerifyEmailResponse {
  final String message;
  final String token;

  VerifyEmailResponse({required this.message, required this.token});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      token: json['token'],
      message: json['message'],
    );
  }
}
