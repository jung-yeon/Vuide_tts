import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../LoginPage/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isAgreeTerms = false;
  bool? _isIdDuplicated;
  bool _isFormValid = false; // 폼의 유효성을 저장할 변수

  TextEditingController _idController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String? _passwordError;

  FocusNode _idFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _idFocus.addListener(_onFocusChange);

    // 모든 입력창의 변화를 감지하여 폼의 유효성을 검사합니다.
    _idController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _passwordConfirmController.addListener(_checkFormValidity);
    _nameController.addListener(_checkFormValidity);
  }

  void _onFocusChange() {
    if (!_idFocus.hasFocus) {
      _checkIdDuplication().then((statusCode) {
        if (statusCode == 200) {
          setState(() {
            _isIdDuplicated = false;
          });
        } else if (statusCode == 400) {
          setState(() {
            _isIdDuplicated = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('서버 통신 오류'))
          );
        }
      });
    }
  }

  void _toggleTerms() {
    setState(() {
      _isAgreeTerms = !_isAgreeTerms;
    });
  }

  Future<int> _checkIdDuplication() async {
    String userId = _idController.text;
    String checkDuplicationUrl = 'http://192.168.20.87:5000/check_id';

    Map<String, String> data = {
      'username': userId,
    };

    final response = await http.post(
      Uri.parse(checkDuplicationUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode;
  }

  void _validatePassword() {
    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() {
        _passwordError = '비밀번호가 일치하지 않습니다.';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _registerUser() async {
    String registerUrl = 'http://192.168.20.87:5000/register';

    Map<String, String> data = {
      'username': _idController.text,
      'name': _nameController.text,
      'password': _passwordController.text,
      'email': _emailController.text,
      'p_number': _phoneController.text,
    };

    final response = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 성공')));
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패')));
    }
  }

  void _onSignUp() {
    if (!_isAgreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이용약관에 동의해주세요.')),
      );
      return;
    }
    _checkIdDuplication().then((statusCode) {
      if (statusCode == 200) {
        print('정상정상');
        setState(() {
          _isIdDuplicated = false;
        });
        _registerUser();
      } else if (statusCode == 400) {
        print('중복');
        setState(() {
          _isIdDuplicated = true;
        });
      } else {
        print('이상이상');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서버 통신 오류')),
        );
      }
    });
  }

  void _checkFormValidity() {
    bool formIsValid =
        _idController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _passwordConfirmController.text.isNotEmpty &&
            _nameController.text.isNotEmpty;

    setState(() {
      _isFormValid = formIsValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/logo_color.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Text(
                '회원가입을 위해 아래 정보를 입력해주세요.',
                style: TextStyle(
                  color: Color(0xff6C54FF),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _idController,
                      focusNode: _idFocus,
                      decoration: InputDecoration(
                        hintText: '아이디',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                    if (_isIdDuplicated != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _isIdDuplicated! ? "중복된 아이디입니다." : "사용 가능한 아이디입니다.",
                          style: TextStyle(
                            color: _isIdDuplicated! ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: '이름',
                        prefixIcon: Icon(Icons.edit_rounded),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      onChanged: (value) => _validatePassword(),
                      decoration: InputDecoration(
                        hintText: '비밀번호',
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordConfirmController,
                      onChanged: (value) => _validatePassword(),
                      decoration: InputDecoration(
                        hintText: '비밀번호 확인',
                        prefixIcon: Icon(Icons.lock),
                        errorText: _passwordError,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: '이메일',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '전화번호',
                        prefixIcon: Icon(Icons.phone),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAgreeTerms,
                          onChanged: (bool? value) {
                            _toggleTerms();
                          },
                        ),
                        Text('이용약관에 동의합니다.'),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? _onSignUp : null,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff6C54FF),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('회원가입'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('이미 계정이 있으신가요? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                          },
                          child: Text('로그인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _idFocus.removeListener(_onFocusChange);
    _idFocus.dispose();

    _idController.removeListener(_checkFormValidity);
    _emailController.removeListener(_checkFormValidity);
    _phoneController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _passwordConfirmController.removeListener(_checkFormValidity);
    _nameController.removeListener(_checkFormValidity);

    super.dispose();
  }
}

