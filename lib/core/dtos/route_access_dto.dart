class RouteAccessResponse {
  final String message;

  RouteAccessResponse({required this.message});

  factory RouteAccessResponse.fromJson(Map<String, dynamic> json) {
    return RouteAccessResponse(
      message: json['message'],
    );
  }
}
