import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../Welcome.dart' as Welcome;
import 'login.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  State<UserSignup> createState() => _UserSignupState();
}

Future<List> createUser(String email, String firstName, String lastName,
    String username, String password) async {
  final response =
      await http.post(Uri.parse('http://localhost:8000/api/users/register/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "username": username,
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password
          }));
  return [response.body, response.statusCode];
}

class _UserSignupState extends State<UserSignup> {
  TextEditingController _email = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String _msg = "";
  bool _isVisible = false;

  void changeText(String msg) {
    setState(() {
      var data = jsonDecode(msg);
      var userNameMsg = "";
      var emailMsg = "";
      var passwordMsg = "";
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
      _msg = (emailMsg + passwordMsg + userNameMsg);
    });
  }

  void showMsg() {
    setState(() {
      _isVisible = !(_msg == "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('WIINGS'),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/Signup.png'), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 100, 10, 100),
            child: ListView(
              children: [
                SizedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _firstName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _lastName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _userName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
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
                  padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                  child: ElevatedButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        String emailValue = _email.text.trim();
                        String firstName = _firstName.text.trim();
                        String lastName = _lastName.text.trim();
                        String usernameValue = _userName.text.trim();
                        String passwordValue = _pass.text.trim();
                        Future<List> signUpResponse = createUser(emailValue,
                            firstName, lastName, usernameValue, passwordValue);
                        List awaitedSignUpResponse = await signUpResponse;
                        if (awaitedSignUpResponse[1] == 201) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Userlogin()),
                              (route) => false);
                        } else {
                          changeText(awaitedSignUpResponse[0]);
                          showMsg();
                        }
                      }),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Userlogin()));
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
