import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrun/common/layout/default_layout.dart';
import 'package:infrun/common/secure_storage/secure_storage.dart';
import 'package:infrun/common/view/root_tab.dart';
import 'package:infrun/user/view/login_screen.dart';

import '../const/colors.dart';
import '../const/data.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // UI를 그리고
    super.initState();
    // Async 함수를 실행한다.
    checkToken();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try{
      // Token 재발행
      final resp = await dio.post('http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          )
      );

      // Token 값 저장
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      // 정상 재발행 되면, RootTab 으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return RootTab();
        },), (route) => false,
      );

    }catch(e){
      // Error 발생 시, 로그인 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return LoginScreen();
        },), (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backGroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        )
    );
  }
}
