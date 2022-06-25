import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'AUTHENTICATION/login.dart' as login;
import 'constants.dart' as constants;
import 'Welcome.dart' as welcome;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WIINGS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppPage(title: 'WIINGS'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/Homepage.png'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white.withOpacity(0.01)),
                  )),
              const Text(
                'WELCOME TO ',
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
              Image.asset('images/Logo.png', height: 350, width: 350),
              Container(
                height: 20,
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (constants.user.token == null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login.Userlogin()),
                          (route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => welcome.WelcomePage()),
                          (route) => false);
                    }
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
