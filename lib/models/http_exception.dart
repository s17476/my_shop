class HttpException implements Exception {
  final int statusCode;
  String? message;

  HttpException({required this.statusCode});

  HttpException.message({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return 'Http status code: $statusCode';
  }
}
