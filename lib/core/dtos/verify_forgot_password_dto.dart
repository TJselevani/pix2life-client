class VerifyForgotPasswordResponse {
  final String message;

  VerifyForgotPasswordResponse({required this.message});

  factory VerifyForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return VerifyForgotPasswordResponse(
      message: json['message'],
    );
  }
}
