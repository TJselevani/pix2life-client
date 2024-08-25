class ApplicationError implements Exception {
  final String message;
  final int status;

  ApplicationError({String? message, int? status})
      : message = message ?? 'ApplicationError',
        status = status ?? 500;

  Map<String, dynamic> serialize() {
    return {'message': message, 'status': status};
  }

  @override
  // String toString() => 'ApplicationError: $message (status: $status)';
  String toString() => message;
}
