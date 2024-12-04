import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infrun/common/const/colors.dart';
import 'package:infrun/common/const/data.dart';
import 'package:infrun/common/layout/default_layout.dart';
import 'package:infrun/common/secure_storage/secure_storage.dart';
import 'package:infrun/common/view/root_tab.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final bool loginFailed;

  const LoginScreen({Key? key, this.loginFailed = false}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String passward = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    if (widget.loginFailed) {
      Future.microtask(
        () => showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text('로그인 오류'),
            content: Text('로그인 아이디 및 비밀번호가 일치하지 않습니다.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('확인'))
            ],
          );
        },),
      );
    }

    return DefaultLayout(
        child: SingleChildScrollView(
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(),
              const SizedBox(
                height: 16,
              ),
              _SubTitle(),
              Image.asset(
                'asset/img/misc/logo.png',
                width: MediaQuery.of(context).size.width / 3 * 2,
              ),
              CustomTextFormField(
                hintText: '이메일을 입력해주세요',
                autofocus: true,
                onChanged: (String value) {
                  username = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                hintText: '비밀번호를 입력해주세요',
                obscureText: true,
                onChanged: (String value) {
                  passward = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  // ID : PW
                  final rawString = '$username:$passward';

                  // Base64 Encoder
                  Codec<String, String> stringToBase64 = utf8.fuse(base64);
                  String token = stringToBase64.encode(rawString);

                  try
                  {
                    final resp = await dio.post('http://$ip/auth/login',
                        options: Options(
                          headers: {
                            'authorization': 'Basic $token',
                          },
                        ));

                    // Json 데이터 접근 시, 아래와 같이.
                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];
                    final storage = ref.read(secureStorageProvider);

                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          return RootTab();
                        },
                      ),(route) => false,
                    );
                  }
                  catch(e){
                    Future.microtask(
                          () => showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text('로그인 오류'),
                          content: Text('아이디와 비밀번호가 일치하지 않습니다.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('확인'))
                          ],
                        );
                      },),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white),
                child: Text('로그인'),
              ),
              TextButton(
                onPressed: () async {},
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: Text(
                  '회원가입',
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
