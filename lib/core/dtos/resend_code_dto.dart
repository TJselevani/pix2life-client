class ResendCodeResponse {
  final String message;

  ResendCodeResponse({required this.message});

  factory ResendCodeResponse.fromJson(Map<String, dynamic> json) {
    return ResendCodeResponse(
      message: json['message'],
    );
  }
}
