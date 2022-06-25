import 'dart:convert';
import 'dart:html';
import 'package:rest_app/Profile.dart';
import 'constants.dart' as constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

String name = "";
String summary = "";

Future<List> getImage() async {
  var _picker = ImagePicker();
  XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    String base64Image = base64Encode(await pickedImage.readAsBytes());
    return [base64Image, 0];
  } else {
    return ["Error in picking image", 1];
  }
}

Future<List> searchImage(String encodedImage) async {
  String username = (constants.user.username ?? "NA");
  String token = "Bearer " + (constants.user.token ?? "NA");
  String title = username + "_" + "$DateTime.now().millisecondsSinceEpoch";
  final response = await http.post(
      Uri.parse('http://localhost:8000/api/imageSearch/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "title": title,
        "image": encodedImage
      }));
  return [response.body, response.statusCode];
}

Future<List> nameSearch(String name) async {
  String token = "Bearer " + (constants.user.token ?? "NA");
  final response =
      await http.post(Uri.parse('http://localhost:8000/api/nameSearch/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          body: jsonEncode(<String, String>{"name": name}));
  return [response.body, response.statusCode];
}

Future<List> locationSearch(String location) async {
  String token = "Bearer " + (constants.user.token ?? "NA");
  final response =
      await http.post(Uri.parse('http://localhost:8000/api/locationSearch/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          body: jsonEncode(<String, String>{"location": location}));
  return [response.body, response.statusCode];
}

Future<List> getProfile(String username) async {
  String token = "Bearer " + (constants.user.token ?? "NA");
  final response =
      await http.post(Uri.parse('http://localhost:8000/api/profile/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
          body: jsonEncode(<String, String>{"username": username}));
  return [response.body, response.statusCode];
}

MemoryImage imageFromBase64String(String base64String) {
  return MemoryImage(base64Decode(base64String));
}

class _WelcomePageState extends State<WelcomePage> {
  String _imageStr = "";
  TextEditingController _name = TextEditingController();

  void displayImage(String imgStr) {
    setState(() {
      _imageStr = imgStr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              bottom: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.image),
                    text: 'Search with image',
                  ),
                  Tab(
                    icon: Icon(Icons.text_format),
                    text: 'Search with text',
                  ),
                  // Tab(
                  //   icon: Icon(Icons.map),
                  //   text: 'Search with hotspots',
                  // ),
                  Tab(
                    icon: Icon(Icons.account_box),
                    text: 'Profile',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    IconButton(
                        onPressed: () async {
                          Future<List> resp = getImage();
                          List awaitedResp = await resp;
                          if (awaitedResp[1] == 0) {
                            Future<List> imageResp =
                                searchImage(awaitedResp[0]);
                            List awaitedImageResp = await imageResp;
                            if (awaitedImageResp[1] == 201) {
                              String responseData = awaitedImageResp[0];
                              var data = jsonDecode(responseData);
                              displayImage(data['image_base64_encoded']);
                            } else {
                              print("Not Working");
                            }
                          } else {
                            print("Not Working");
                          }
                        },
                        icon: Icon(Icons.file_upload)),
                    SizedBox(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        padding: const EdgeInsets.fromLTRB(500, 50, 500, 50),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageFromBase64String("$_imageStr"),
                        )),
                      ),
                    ),
                  ],
                ),
                ListView(children: [
                  IconButton(
                      onPressed: () async {
                        Future<List> response = nameSearch(_name.text.trim());
                        List awaitedRepsonse = await response;
                        if (awaitedRepsonse[1] == 200) {
                          var parsedData = jsonDecode(awaitedRepsonse[0]);
                          name = parsedData['title']['name'] ?? "NA";
                          summary = parsedData['summary'] ?? "NA";
                          print(summary);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayDetails()),
                              (route) => false);
                        } else {
                          print("Not Working");
                        }
                      },
                      icon: Icon(Icons.search)),
                  SizedBox(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(500, 10, 500, 10),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the Bird Name',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ]),
                // Icon(
                //   Icons.map, size: 350,
                //   // Text('This page is to search using Hotspots'),
                // ),
                IconButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  icon: Icon(
                    Icons.account_box,
                    size: 350,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class DisplayDetails extends StatefulWidget {
  DisplayDetails({Key? key}) : super(key: key);

  @override
  State<DisplayDetails> createState() => _DisplayDetailsState();
}

class _DisplayDetailsState extends State<DisplayDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Search for : $name')),
      body: Container(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              SizedBox(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'About',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.blue[300],
                child: Center(
                  child: Text('Name : $name',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.blue[300],
                child: Center(
                  child: Text('Summary : $summary',
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
