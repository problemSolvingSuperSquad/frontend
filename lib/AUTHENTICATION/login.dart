import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import '../Welcome.dart';
import 'Signup.dart';
import '../constants.dart' as constants;

Future<List> loginUser(String username, String password) async {
  final response = await http.post(
      Uri.parse('http://localhost:8000/api/users/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"username": username, "password": password}));
  return [response.body, response.statusCode];
}

class Userlogin extends StatefulWidget {
  const Userlogin({Key? key}) : super(key: key);

  @override
  State<Userlogin> createState() => _UserloginState();
}

class _UserloginState extends State<Userlogin> {
  TextEditingController _username = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String _msg = "";
  bool _isVisible = false;

  void changeText(String msg) {
    setState(() {
      var data = jsonDecode(msg);
      var dMsg = "";
      var userNameMsg = "";
      var emailMsg = "";
      var passwordMsg = "";
      if (data['detail'] != null) {
        dMsg = data['detail'];
      }
      if (data['username'] != null) {
        userNameMsg = data['username']
            .map((x) => "Username: $x\n")
            .reduce((x, y) => "$x$y");
      }
      if (data['email'] != null) {
        emailMsg =
            data['email'].map((x) => "Email: $x\n").reduce((x, y) => "$x$y");
      }
      if (data['password'] != null) {
        passwordMsg = data['password']
            .map((x) => "Password: $x\n")
            .reduce((x, y) => ("$x$y"));
      }
      _msg = (dMsg + emailMsg + passwordMsg + userNameMsg);
    });
  }

  void showMsg() {
    setState(() {
      _isVisible = !(_msg == "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('WIINGS'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/Loginpage.png'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 100, 10, 100),
          child: ListView(
            children: [
              SizedBox(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: _pass,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {}, child: const Text('Forgot Password')),
              Visibility(
                visible: _isVisible,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                  child: Text(
                    '$_msg',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                child: ElevatedButton(
                  child: const Text('Sign In'),
                  onPressed: () async {
                    String usernameValue = _username.text.trim();
                    String passwordValue = _pass.text.trim();
                    Future<List> loginResponse =
                        loginUser(usernameValue, passwordValue);
                    List awaitedLoginResponse = await loginResponse;
                    if (awaitedLoginResponse[1] == 200) {
                      var data = jsonDecode(awaitedLoginResponse[0]);
                      String token = data['access'];
                      constants.user =
                          constants.UserDetails(usernameValue, token);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                          (route) => false);
                    } else {
                      changeText(awaitedLoginResponse[0]);
                      showMsg();
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Do not have an account?',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSignup()));
                    },
                    child: const Text('Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
