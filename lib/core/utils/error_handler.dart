class ErrorHandler {
  ErrorHandler._();

  static String extractErrorMessage(Object error) {
    final errorMsg = error.toString();
    return errorMsg.contains('Exception: ')
        ? errorMsg.split('Exception: ').last
        : errorMsg;
  }

  static String extractApiErrorMessage(dynamic response) {
    if (response == null) return 'Unknown error occurred';

    if (response is Map<String, dynamic>) {
      return response['message'] as String? ??
          response['error'] as String? ??
          'Unknown error occurred';
    }

    return extractErrorMessage(response);
  }
}
