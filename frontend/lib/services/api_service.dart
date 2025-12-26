import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  final String baseUrl;
  final String env;
  late final Dio dio;
  final logger = Logger();

  ApiService({required this.baseUrl, required this.env}) {
    _initializeDio();
  }

  void _initializeDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        // Increased timeouts to handle cold starts and slow network responses
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      LoggingInterceptor(logger: logger),
      ErrorInterceptor(logger: logger),
    ]);
  }
}

/// Logging interceptor
class LoggingInterceptor extends Interceptor {
  final Logger logger;

  LoggingInterceptor({required this.logger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('➡️  REQUEST: ${options.method} ${options.uri}');
    logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      logger.d('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      '⬅️  RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    logger.d('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
    logger.e('Message: ${err.message}');
    handler.next(err);
  }
}

/// Error handling interceptor
class ErrorInterceptor extends Interceptor {
  final Logger logger;

  ErrorInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Something went wrong';

    if (err.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout. Please check your network.';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Server took too long to respond.';
    } else if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      final data = err.response?.data;

      if (statusCode == 400) {
        errorMessage = data?['error'] ?? 'Invalid request';
      } else if (statusCode == 404) {
        errorMessage = 'Resource not found';
      } else if (statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      } else {
        errorMessage = data?['error'] ?? 'An error occurred';
      }
    } else if (err.type == DioExceptionType.unknown) {
      errorMessage = 'Network error. Check your internet connection.';
    }

    logger.e('Normalized Error: $errorMessage');

    // Pass through the exception with error message in the logger
    handler.next(err);
  }
}
