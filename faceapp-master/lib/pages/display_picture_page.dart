import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

String username='';

class DisplayPicturePage extends StatefulWidget {
  final String imagePath;
  final Map<String, String> data;
  DisplayPicturePage({this.data, this.imagePath});

  @override
  _DisplayPicturePageState createState() => _DisplayPicturePageState();
}

class _DisplayPicturePageState extends State<DisplayPicturePage> {

  void _sendData() async {
    File file;

    file = File(widget.imagePath);
    String base64Image = base64Encode(file.readAsBytesSync());

    widget.data['image'] = base64Image;

    var res = await CallApi().postData(widget.data, 'register');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
  }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage()
        // builder: (context) => TestMyApp(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    // Future<List> senddata() async {
    //   final response = await http.post("http://localhost/api/postpic", body: {
    //     "name": name.text,
    //     "email": email.text,
    //     "mobile":mobile.text,
    //   });
    // }

    return Scaffold(
      appBar: AppBar(title: Text('Detecting face')),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Image.file(File(widget.imagePath)),
              // Text("Username",style: TextStyle(fontSize: 18.0),),
              // TextField(
              //   controller: name,
              //   decoration: InputDecoration(
              //       hintText: 'name'
              //   ),
              // ),
              // Text("Email",style: TextStyle(fontSize: 18.0),),
              // TextField(
              //   controller: email,
              //   decoration: InputDecoration(
              //       hintText: 'Email'
              //   ),
              // ),
              // Text("Mobile",style: TextStyle(fontSize: 18.0),),
              // TextField(
              //   controller: mobile,
              //   decoration: InputDecoration(
              //       hintText: 'Mobile'
              //   ),
              // ),

              RaisedButton(
                child: Text("Register"),
                onPressed: (){
                  _sendData();
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
