import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:3000/api', // Para emulador Android
    // baseUrl: 'http://localhost:3000/api', // Para iOS
    // baseUrl: 'http://192.168.1.X:3000/api', // Para dispositivo físico
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Interceptor para logging
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('REQUEST: ${options.method} ${options.path}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('RESPONSE: ${response.statusCode}');
      return handler.next(response);
    },
    onError: (error, handler) {
      print('ERROR: ${error.message}');
      return handler.next(error);
    },
  ));

  return dio;
});
