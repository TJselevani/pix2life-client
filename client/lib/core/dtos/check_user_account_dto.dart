class CheckUserAccountResponse {
  final String message;

  CheckUserAccountResponse({required this.message});

  factory CheckUserAccountResponse.fromJson(Map<String, dynamic> json) {
    return CheckUserAccountResponse(
      message: json['message'],
    );
  }
}
