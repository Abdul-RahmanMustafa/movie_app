import 'package:dio/dio.dart';

enum YtsApiClientFailureType { network, timeout, invalidResponse }

class YtsApiClientException implements Exception {
  const YtsApiClientException(this.type);

  final YtsApiClientFailureType type;
}

abstract interface class YtsApiClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
}

class DioYtsApiClient implements YtsApiClient {
  DioYtsApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  static const String baseUrl = 'https://movies-api.accel.li/api/v2/';

  final Dio _dio;

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      throw const YtsApiClientException(
        YtsApiClientFailureType.invalidResponse,
      );
    } on YtsApiClientException {
      rethrow;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final responseBody = error.response?.data;
        if (responseBody is Map<String, dynamic>) return responseBody;
        if (responseBody is Map) {
          return Map<String, dynamic>.from(responseBody);
        }
      }
      final type = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => YtsApiClientFailureType.timeout,
        DioExceptionType.badResponse => YtsApiClientFailureType.invalidResponse,
        _ => YtsApiClientFailureType.network,
      };
      throw YtsApiClientException(type);
    } catch (_) {
      throw const YtsApiClientException(
        YtsApiClientFailureType.invalidResponse,
      );
    }
  }
}
