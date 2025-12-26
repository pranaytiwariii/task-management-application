import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

/// Dio/ApiService provider
final apiServiceProvider = Provider<ApiService>((ref) {
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  return ApiService(baseUrl: baseUrl, env: env);
});
