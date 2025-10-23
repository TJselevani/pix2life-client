class CreatePasswordResponse {
  final String userEmail;
  final String message;

  CreatePasswordResponse({required this.userEmail, required this.message});

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return CreatePasswordResponse(
      userEmail: json['userEmail'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
