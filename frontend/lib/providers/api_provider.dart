import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

/// Dio/ApiService provider
final apiServiceProvider = Provider<ApiService>((ref) {
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://task-management-backend-p3oj.onrender.com',
  );
  const env = String.fromEnvironment('ENV', defaultValue: 'production');

  return ApiService(baseUrl: baseUrl, env: env);
});
