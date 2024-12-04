import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infrun/common/const/data.dart';
import 'package:infrun/common/secure_storage/secure_storage.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  //요청이 보내질때마다
  // 헤더에 accessToken 에 true 값이 있다면, storage 에서 token을 가져와 넣는다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');
      // 실제 토큰 값 리드
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      // 실제 값으로 대체
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshoToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // Log 로 사용할 수도 있다.
    print('[REQ] [${options.method}] ${options.uri}');

    // 실제 요청이 보내지는 직전
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Token 에 문제가 생겼을 때 status code 401 -> 토큰을 재발급받는 시도

    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.path}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 이 없으면
    // 당연히 에러를 던진다.
    if (refreshToken == null) {
      // Error 를 던지는 방법은 handler.reject 를 사용한다.
      return handler.reject(err);
      // Error 가 없는 경우로 만들어서 response 를 넣어줄 수 있다.
      // return handler.resolve(response)
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post('http://$ip/auth/token',
            options:
                Options(headers: {'authorization': 'Bearer $refreshToken'}));

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // 토큰 변경
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        //Secure storage 업데이트
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        // 성공된 요청을 다시 보낸다.
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
    // return super.onError(err, handler);
  }
}
