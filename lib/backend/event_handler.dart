// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class HttpService {
//   late Dio _dio;
//   final String baseUrl = 'https://api.seatgeek.com/2/';
//   HttpService() {
//     _dio = Dio(BaseOptions(
//       baseUrl: 'https://api.seatgeek.com/2',
//     ));
//     initializeInterceptors();
//   }

//   Future<Response> getRequest(String endPoint) async {
//     try {
//       final Response response = await _dio.get(baseUrl + endPoint + '&client_id=MjY3NzA0MTB8MTY1MTI1MTQwOS4wNTAzNTY');
//       return response;
//     } on DioError catch (e) {
//       if (kDebugMode) {
//         print(e.message);
//       }
//       throw Exception(e.message);
//     }
//   }

//   initializeInterceptors() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onError: (dioError, errorInterceptorHandler) {
//         if (kDebugMode) {
//           print("@@@@ DIO ERROR: ${dioError.message}");
//         }
//       },
//       onRequest: (requestOptions, requestInterceptorHandler) {
//         if (kDebugMode) {
//           print("@@@@@@ REQUEST METHOD: ${requestOptions.method}\n@@@@@@ REQUEST PATH: ${requestOptions.path}");
//         }
//       },
//       onResponse: (response, responseInterceptorHandler) {
//         if (kDebugMode) {
//           print("@@@@@@ RESPONSE DATA: ${response.data}");
//         }
//       },
//     ));
//   }
// }
