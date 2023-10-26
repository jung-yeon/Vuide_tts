
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../SignUpPage/signup.dart';
import '../home.dart';


class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Login({super.key});

  Future<int> login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // 서버 엔드포인트 URL을 설정합니다.
    String loginUrl = 'http://192.168.20.87:5000/login';

    // 로그인 데이터를 준비합니다.
    Map<String, String> data = {
      'username': username,
      'password': password,
    };

    // 서버에 POST 요청을 보냅니다.
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8D9BE5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Image.asset("assets/logo2.png", width: 150, height: 150),
            Text(
              '로그인 후 서비스를 이용해주세요',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff6C54FF),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                filled: true,
                fillColor: Colors.white,
                labelText: '아이디',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 6),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                filled: true,
                fillColor: Colors.white,
                labelText: '비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff6C54FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async {
                int serverState = await login();
                if (serverState == 200) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                }else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                }

              },
              child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text('회원가입', style: TextStyle(color: Color(0xff6C54FF))),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('아이디 찾기', style: TextStyle(color: Color(0xff6C54FF))),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('비밀번호 찾기', style: TextStyle(color: Color(0xff6C54FF))),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff2DB400),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('N', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(width: 10),
                      Text('네이버로 로그인', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFEE500),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/kakaologo.png", width: 25, height: 25),
                      SizedBox(width: 10),
                      Text('카카오로 로그인', style: TextStyle(color: Colors.brown)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}