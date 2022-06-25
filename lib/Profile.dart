import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

String name = constants.user.username ?? "NA";

class _ProfileState extends State<Profile> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Profile"),
      ),
      body: Container(
        child: Center(
          child: Container(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                SizedBox(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'My Profile',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                  child: Center(
                    child: Text('User Name: $name',
                    
                        style: TextStyle(color: Colors.black, fontSize: 25)),
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
