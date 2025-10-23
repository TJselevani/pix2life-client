class VerifyResetCodeResponse {
  final String message;

  VerifyResetCodeResponse({required this.message});

  factory VerifyResetCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeResponse(
      message: json['message'],
    );
  }
}
