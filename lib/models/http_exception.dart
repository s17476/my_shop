class HttpException implements Exception {
  final int statusCode;

  HttpException({required this.statusCode});

  @override
  String toString() {
    return 'Http status code: $statusCode';
  }
}
