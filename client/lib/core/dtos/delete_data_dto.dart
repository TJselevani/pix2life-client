class DeleteDataResponse {
  final String message;

  DeleteDataResponse({required this.message});

  factory DeleteDataResponse.fromJson(Map<String, dynamic> json) {
    return DeleteDataResponse(
      message: json['message'],
    );
  }
}
